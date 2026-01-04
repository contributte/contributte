#!/usr/bin/env bun

/**
 * Script to check how many commits are ahead of the last tag for all repositories
 * in the contributte organization. Helps identify repositories that need a new release.
 *
 * Usage: bun scripts/check-releases.ts
 */

import {
  executeGraphQL,
  executeRestAPI,
  type BaseGraphQLResponse,
  formatDate,
  printMarkdownTable,
  ORGANIZATION,
} from "./utils";

// TypeScript Interfaces
interface TagRef {
  name: string;
  target: {
    oid: string;
    committedDate?: string;
    tagger?: {
      date: string;
    };
    target?: {
      committedDate?: string;
    };
  };
}

interface GitHubRepository {
  name: string;
  url: string;
  isArchived: boolean;
  defaultBranchRef: {
    name: string;
    target: {
      oid: string;
    };
  } | null;
  refs: {
    nodes: TagRef[];
  };
}

interface GraphQLResponse extends BaseGraphQLResponse {
  data: {
    organization: {
      repositories: {
        pageInfo: {
          hasNextPage: boolean;
          endCursor: string | null;
        };
        nodes: GitHubRepository[];
      };
    };
  };
}

interface ReleaseStatus {
  name: string;
  url: string;
  aheadBy: number;
  latestTag: string;
  tagDate: string;
}

interface ArchivedRepo {
  name: string;
  url: string;
  latestTag: string;
  tagDate: string;
}

interface RepoWithoutTag {
  name: string;
  url: string;
}

const QUERY = `
  query($cursor: String) {
    organization(login: "${ORGANIZATION}") {
      repositories(first: 100, after: $cursor, orderBy: {field: UPDATED_AT, direction: DESC}) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          name
          url
          isArchived
          defaultBranchRef {
            name
            target {
              ... on Commit {
                oid
              }
            }
          }
          refs(refPrefix: "refs/tags/", first: 1, orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {
            nodes {
              name
              target {
                oid
                ... on Commit {
                  committedDate
                }
                ... on Tag {
                  tagger {
                    date
                  }
                  target {
                    ... on Commit {
                      committedDate
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
`;

/**
 * Extract date from tag ref (handles both lightweight and annotated tags)
 */
function getTagDate(tagRef: TagRef): string {
  const target = tagRef.target;
  // Lightweight tag - points directly to commit
  if (target.committedDate) {
    return formatDate(target.committedDate);
  }
  // Annotated tag - has tagger info
  if (target.tagger?.date) {
    return formatDate(target.tagger.date);
  }
  // Annotated tag - get date from target commit
  if (target.target?.committedDate) {
    return formatDate(target.target.committedDate);
  }
  return "unknown";
}

/**
 * Compare two refs and get the ahead_by count
 */
async function compareRefs(
  repoName: string,
  base: string,
  head: string
): Promise<number> {
  const result = await executeRestAPI(
    `repos/${ORGANIZATION}/${repoName}/compare/${base}...${head}`,
    ".ahead_by"
  );

  if (result === null) {
    return 0;
  }

  const aheadBy = parseInt(result, 10);
  return isNaN(aheadBy) ? 0 : aheadBy;
}

/**
 * Fetch all repositories from the organization
 */
async function fetchAllRepositories(): Promise<GitHubRepository[]> {
  const repositories: GitHubRepository[] = [];
  let cursor: string | null = null;
  let hasNextPage = true;
  let pageCount = 0;

  console.log(`Fetching repositories from ${ORGANIZATION} organization...`);

  while (hasNextPage) {
    pageCount++;
    console.log(`  Fetching page ${pageCount}...`);

    const response = await executeGraphQL<GraphQLResponse>(QUERY, { cursor });
    const { pageInfo, nodes } = response.data.organization.repositories;

    repositories.push(...nodes);
    hasNextPage = pageInfo.hasNextPage;
    cursor = pageInfo.endCursor;
  }

  console.log(`Fetched ${repositories.length} repositories\n`);

  return repositories;
}

/**
 * Get archived repositories with their latest tags
 */
function getArchivedRepos(repos: GitHubRepository[]): ArchivedRepo[] {
  return repos
    .filter((r) => r.isArchived && r.refs.nodes.length > 0)
    .map((r) => ({
      name: r.name,
      url: r.url,
      latestTag: r.refs.nodes[0].name,
      tagDate: getTagDate(r.refs.nodes[0]),
    }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

/**
 * Get active repositories without any tags
 */
function getReposWithoutTags(repos: GitHubRepository[]): RepoWithoutTag[] {
  return repos
    .filter((r) => !r.isArchived && r.refs.nodes.length === 0)
    .map((r) => ({
      name: r.name,
      url: r.url,
    }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

/**
 * Check release status for all repositories
 */
async function checkReleaseStatus(
  repos: GitHubRepository[]
): Promise<ReleaseStatus[]> {
  const results: ReleaseStatus[] = [];
  const activeRepos = repos.filter((r) => !r.isArchived);

  console.log(`Checking release status for ${activeRepos.length} active repositories...`);

  let processed = 0;
  const batchSize = 10;

  for (let i = 0; i < activeRepos.length; i += batchSize) {
    const batch = activeRepos.slice(i, i + batchSize);

    const batchResults = await Promise.all(
      batch.map(async (repo) => {
        // Skip repos without default branch or tags
        if (!repo.defaultBranchRef || repo.refs.nodes.length === 0) {
          return null;
        }

        const tagRef = repo.refs.nodes[0];
        const latestTag = tagRef.name;
        const defaultBranch = repo.defaultBranchRef.name;

        const aheadBy = await compareRefs(repo.name, latestTag, defaultBranch);

        if (aheadBy > 0) {
          return {
            name: repo.name,
            url: repo.url,
            aheadBy,
            latestTag,
            tagDate: getTagDate(tagRef),
          };
        }

        return null;
      })
    );

    results.push(...batchResults.filter((r): r is ReleaseStatus => r !== null));
    processed += batch.length;
    process.stdout.write(`\r  Processed ${processed}/${activeRepos.length} repositories`);
  }

  console.log("\n");

  return results;
}

/**
 * Print results as markdown tables
 */
function printResults(
  results: ReleaseStatus[],
  reposWithoutTags: RepoWithoutTag[],
  archivedRepos: ArchivedRepo[]
): void {
  // Sort by commits ahead (descending)
  const sorted = results.sort((a, b) => b.aheadBy - a.aheadBy);

  // Print active repos with unreleased changes
  console.log("## Repositories with Unreleased Changes\n");

  if (sorted.length === 0) {
    console.log("All repositories are up to date with their latest tags.\n");
  } else {
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Commits Ahead", align: "right" },
        { header: "Latest Tag" },
        { header: "Tag Date" },
      ],
      rows: sorted.map((r) => [
        r.name,
        r.aheadBy.toString(),
        r.latestTag,
        r.tagDate,
      ]),
    });

    // Summary
    const totalCommits = sorted.reduce((sum, r) => sum + r.aheadBy, 0);
    console.log(`\n**Summary:** ${sorted.length} repositories with ${totalCommits} total commits pending release\n`);
  }

  // Print repos without tags
  if (reposWithoutTags.length > 0) {
    console.log("\n## Repositories Without Tags (Never Released)\n");
    printMarkdownTable({
      columns: [{ header: "Repository" }],
      rows: reposWithoutTags.map((r) => [r.name]),
    });
    console.log(`\n**Total repositories without tags:** ${reposWithoutTags.length}`);
  }

  // Print archived repos
  if (archivedRepos.length > 0) {
    console.log("\n## Archived Repositories\n");
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Latest Tag" },
        { header: "Tag Date" },
      ],
      rows: archivedRepos.map((r) => [r.name, r.latestTag, r.tagDate]),
    });
    console.log(`\n**Total archived repositories:** ${archivedRepos.length}`);
  }
}

/**
 * Main execution
 */
async function main() {
  try {
    const repositories = await fetchAllRepositories();
    const releaseStatus = await checkReleaseStatus(repositories);
    const reposWithoutTags = getReposWithoutTags(repositories);
    const archivedRepos = getArchivedRepos(repositories);
    printResults(releaseStatus, reposWithoutTags, archivedRepos);
  } catch (error) {
    console.error("Unexpected error:");
    console.error(error);
    process.exit(1);
  }
}

// Run the script
main();
