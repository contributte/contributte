#!/usr/bin/env bun

/**
 * Script to check for stale repositories in the contributte organization
 * Identifies repos with no recent commits based on pushedAt timestamp
 *
 * Usage: bun scripts/check-activity.ts
 */

import {
  executeGraphQL,
  type BaseGraphQLResponse,
  daysSince,
  formatDate,
  printMarkdownTable,
  THRESHOLDS,
  ORGANIZATION,
} from "./utils";

// TypeScript Interfaces
interface GitHubRepository {
  name: string;
  url: string;
  isArchived: boolean;
  pushedAt: string;
  defaultBranchRef: {
    name: string;
    target: {
      committedDate: string;
    };
  } | null;
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

interface RepoStatus {
  name: string;
  url: string;
  lastCommit: string;
  daysAgo: number;
  status: "active" | "stale" | "neglected";
}

const QUERY = `
  query($cursor: String) {
    organization(login: "${ORGANIZATION}") {
      repositories(first: 100, after: $cursor, orderBy: {field: PUSHED_AT, direction: DESC}) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          name
          url
          isArchived
          pushedAt
          defaultBranchRef {
            name
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
 * Get status based on days since last commit
 */
function getStatus(daysAgo: number): "active" | "stale" | "neglected" {
  if (daysAgo >= THRESHOLDS.neglectedRepo) return "neglected";
  if (daysAgo >= THRESHOLDS.staleRepo) return "stale";
  return "active";
}

/**
 * Analyze repositories for staleness
 */
function analyzeRepositories(repos: GitHubRepository[]): RepoStatus[] {
  const results: RepoStatus[] = [];

  for (const repo of repos) {
    // Skip archived repos
    if (repo.isArchived) continue;

    // Use pushedAt as the primary indicator
    const lastCommitDate = repo.pushedAt;
    const daysAgo = daysSince(lastCommitDate);
    const status = getStatus(daysAgo);

    results.push({
      name: repo.name,
      url: repo.url,
      lastCommit: formatDate(lastCommitDate),
      daysAgo,
      status,
    });
  }

  return results;
}

/**
 * Print results as markdown tables
 */
function printResults(results: RepoStatus[]): void {
  // Separate by status
  const neglected = results.filter((r) => r.status === "neglected");
  const stale = results.filter((r) => r.status === "stale");
  const active = results.filter((r) => r.status === "active");

  // Sort each group by days ago (descending)
  neglected.sort((a, b) => b.daysAgo - a.daysAgo);
  stale.sort((a, b) => b.daysAgo - a.daysAgo);

  // Check if there are any repos to show
  const allRepos = [...neglected, ...stale];
  if (allRepos.length === 0) {
    console.log(`All repositories are active (commits within last ${THRESHOLDS.staleRepo} days).\n`);
    console.log("Summary:");
    console.log(`- Active: ${active.length}`);
    console.log(`- Stale: 0`);
    console.log(`- Neglected: 0`);
    return;
  }

  // Print neglected repos
  if (neglected.length > 0) {
    console.log(`## Neglected Repositories (>${THRESHOLDS.neglectedRepo} days)\n`);
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Last Commit" },
        { header: "Days Ago", align: "right" },
        { header: "Status" },
      ],
      rows: neglected.map((r) => [r.name, r.lastCommit, r.daysAgo.toString(), "neglected"]),
    });
    console.log("");
  }

  // Print stale repos
  if (stale.length > 0) {
    console.log(`## Stale Repositories (${THRESHOLDS.staleRepo}-${THRESHOLDS.neglectedRepo} days)\n`);
    printMarkdownTable({
      columns: [
        { header: "Repository" },
        { header: "Last Commit" },
        { header: "Days Ago", align: "right" },
        { header: "Status" },
      ],
      rows: stale.map((r) => [r.name, r.lastCommit, r.daysAgo.toString(), "stale"]),
    });
    console.log("");
  }

  // Print summary
  console.log("---\n");
  console.log("## Summary\n");
  console.log(`- Active (<${THRESHOLDS.staleRepo} days): ${active.length}`);
  console.log(`- Stale (${THRESHOLDS.staleRepo}-${THRESHOLDS.neglectedRepo} days): ${stale.length}`);
  console.log(`- Neglected (>${THRESHOLDS.neglectedRepo} days): ${neglected.length}`);
  console.log(`- Total active repositories: ${results.length}`);
}

/**
 * Main execution
 */
async function main() {
  try {
    const repositories = await fetchAllRepositories();
    const results = analyzeRepositories(repositories);
    printResults(results);
  } catch (error) {
    console.error("Unexpected error:");
    console.error(error);
    process.exit(1);
  }
}

// Run the script
main();
