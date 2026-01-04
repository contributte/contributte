#!/usr/bin/env bun

/**
 * Script to check open pull requests across all repositories in the contributte organization
 * Reports PR counts, draft PRs, and identifies repos with stale PRs
 *
 * Usage: bun scripts/check-prs.ts
 */

import {
  executeGraphQL,
  type BaseGraphQLResponse,
  daysSince,
  printMarkdownTable,
  THRESHOLDS,
  ORGANIZATION,
} from "./utils";

// TypeScript Interfaces
interface PullRequest {
  title: string;
  url: string;
  createdAt: string;
  isDraft: boolean;
  author: {
    login: string;
  } | null;
}

interface GitHubRepository {
  name: string;
  url: string;
  isArchived: boolean;
  pullRequests: {
    totalCount: number;
    nodes: PullRequest[];
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

interface RepoPRStatus {
  name: string;
  url: string;
  openCount: number;
  draftCount: number;
  oldestDays: number | null;
  oldestPR: PullRequest | null;
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
          pullRequests(states: OPEN, first: 10, orderBy: {field: CREATED_AT, direction: ASC}) {
            totalCount
            nodes {
              title
              url
              createdAt
              isDraft
              author {
                login
              }
            }
          }
        }
      }
    }
  }
`;

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
 * Analyze repositories for open PRs
 */
function analyzeRepositories(repos: GitHubRepository[]): RepoPRStatus[] {
  const results: RepoPRStatus[] = [];

  for (const repo of repos) {
    // Skip archived repos
    if (repo.isArchived) continue;

    // Skip repos with no open PRs
    if (repo.pullRequests.totalCount === 0) continue;

    const prs = repo.pullRequests.nodes;
    const oldestPR = prs[0] || null;
    const oldestDays = oldestPR ? daysSince(oldestPR.createdAt) : null;
    const draftCount = prs.filter((pr) => pr.isDraft).length;

    results.push({
      name: repo.name,
      url: repo.url,
      openCount: repo.pullRequests.totalCount,
      draftCount,
      oldestDays,
      oldestPR,
    });
  }

  return results;
}

/**
 * Print results as markdown tables
 */
function printResults(results: RepoPRStatus[], totalRepos: number): void {
  if (results.length === 0) {
    console.log("No repositories have open pull requests.\n");
    console.log("Summary:");
    console.log(`- Repositories checked: ${totalRepos}`);
    console.log(`- Repositories with open PRs: 0`);
    return;
  }

  // Sort by open count (descending)
  const sorted = results.sort((a, b) => b.openCount - a.openCount);

  // Separate stale from normal
  const staleRepos = sorted.filter(
    (r) => r.oldestDays !== null && r.oldestDays >= THRESHOLDS.stalePR
  );
  const normalRepos = sorted.filter(
    (r) => r.oldestDays === null || r.oldestDays < THRESHOLDS.stalePR
  );

  // Print repos with stale PRs first
  if (staleRepos.length > 0) {
    console.log(`## Repositories with Stale PRs (>${THRESHOLDS.stalePR} days)\n`);
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Open", align: "right" },
        { header: "Draft", align: "right" },
        { header: "Oldest (days)", align: "right" },
      ],
      rows: staleRepos.map((r) => [
        r.name,
        r.openCount.toString(),
        r.draftCount.toString(),
        r.oldestDays?.toString() || "-",
      ]),
    });
    console.log("");
  }

  // Print repos with recent PRs
  if (normalRepos.length > 0) {
    console.log("## Repositories with Open PRs\n");
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Open", align: "right" },
        { header: "Draft", align: "right" },
        { header: "Oldest (days)", align: "right" },
      ],
      rows: normalRepos.map((r) => [
        r.name,
        r.openCount.toString(),
        r.draftCount.toString(),
        r.oldestDays?.toString() || "-",
      ]),
    });
    console.log("");
  }

  // Print summary
  const totalPRs = sorted.reduce((sum, r) => sum + r.openCount, 0);
  const totalDrafts = sorted.reduce((sum, r) => sum + r.draftCount, 0);
  console.log("---\n");
  console.log("## Summary\n");
  console.log(`- Total open PRs: ${totalPRs}`);
  console.log(`- Total draft PRs: ${totalDrafts}`);
  console.log(`- Repositories with open PRs: ${sorted.length}`);
  console.log(`- Repositories with stale PRs (>${THRESHOLDS.stalePR} days): ${staleRepos.length}`);
  console.log(`- Total repositories checked: ${totalRepos}`);
}

/**
 * Main execution
 */
async function main() {
  try {
    const repositories = await fetchAllRepositories();
    const activeRepos = repositories.filter((r) => !r.isArchived);
    const results = analyzeRepositories(repositories);
    printResults(results, activeRepos.length);
  } catch (error) {
    console.error("Unexpected error:");
    console.error(error);
    process.exit(1);
  }
}

// Run the script
main();
