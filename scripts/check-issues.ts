#!/usr/bin/env bun

/**
 * Script to check open issues across all repositories in the contributte organization
 * Reports issue counts and identifies repos with stale issues
 *
 * Usage: bun scripts/check-issues.ts
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
interface Issue {
  title: string;
  url: string;
  createdAt: string;
  author: {
    login: string;
  } | null;
}

interface GitHubRepository {
  name: string;
  url: string;
  isArchived: boolean;
  issues: {
    totalCount: number;
    nodes: Issue[];
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

interface RepoIssueStatus {
  name: string;
  url: string;
  openCount: number;
  oldestDays: number | null;
  oldestIssue: Issue | null;
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
          issues(states: OPEN, first: 10, orderBy: {field: CREATED_AT, direction: ASC}) {
            totalCount
            nodes {
              title
              url
              createdAt
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
 * Analyze repositories for open issues
 */
function analyzeRepositories(repos: GitHubRepository[]): RepoIssueStatus[] {
  const results: RepoIssueStatus[] = [];

  for (const repo of repos) {
    // Skip archived repos
    if (repo.isArchived) continue;

    // Skip repos with no open issues
    if (repo.issues.totalCount === 0) continue;

    const oldestIssue = repo.issues.nodes[0] || null;
    const oldestDays = oldestIssue ? daysSince(oldestIssue.createdAt) : null;

    results.push({
      name: repo.name,
      url: repo.url,
      openCount: repo.issues.totalCount,
      oldestDays,
      oldestIssue,
    });
  }

  return results;
}

/**
 * Print results as markdown tables
 */
function printResults(results: RepoIssueStatus[], totalRepos: number): void {
  if (results.length === 0) {
    console.log("No repositories have open issues.\n");
    console.log("Summary:");
    console.log(`- Repositories checked: ${totalRepos}`);
    console.log(`- Repositories with open issues: 0`);
    return;
  }

  // Sort by open count (descending)
  const sorted = results.sort((a, b) => b.openCount - a.openCount);

  // Separate stale from normal
  const staleRepos = sorted.filter(
    (r) => r.oldestDays !== null && r.oldestDays >= THRESHOLDS.staleIssue
  );
  const normalRepos = sorted.filter(
    (r) => r.oldestDays === null || r.oldestDays < THRESHOLDS.staleIssue
  );

  // Print repos with stale issues first
  if (staleRepos.length > 0) {
    console.log(`## Repositories with Stale Issues (>${THRESHOLDS.staleIssue} days)\n`);
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Open", align: "right" },
        { header: "Oldest (days)", align: "right" },
      ],
      rows: staleRepos.map((r) => [
        r.name,
        r.openCount.toString(),
        r.oldestDays?.toString() || "-",
      ]),
    });
    console.log("");
  }

  // Print repos with recent issues
  if (normalRepos.length > 0) {
    console.log("## Repositories with Open Issues\n");
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Open", align: "right" },
        { header: "Oldest (days)", align: "right" },
      ],
      rows: normalRepos.map((r) => [
        r.name,
        r.openCount.toString(),
        r.oldestDays?.toString() || "-",
      ]),
    });
    console.log("");
  }

  // Print summary
  const totalIssues = sorted.reduce((sum, r) => sum + r.openCount, 0);
  console.log("---\n");
  console.log("## Summary\n");
  console.log(`- Total open issues: ${totalIssues}`);
  console.log(`- Repositories with open issues: ${sorted.length}`);
  console.log(`- Repositories with stale issues (>${THRESHOLDS.staleIssue} days): ${staleRepos.length}`);
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
