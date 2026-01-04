#!/usr/bin/env bun

/**
 * Script to check CI status of all repositories in the contributte organization
 *
 * Usage: bun scripts/check-ci.ts
 */

import {
  executeGraphQL,
  type BaseGraphQLResponse,
  ORGANIZATION,
} from "./utils";

// TypeScript Interfaces
interface StatusCheckRollup {
  state: "SUCCESS" | "FAILURE" | "ERROR" | "PENDING" | "EXPECTED" | null;
}

interface GitHubRepository {
  name: string;
  url: string;
  isArchived: boolean;
  defaultBranchRef: {
    name: string;
    target: {
      statusCheckRollup: StatusCheckRollup | null;
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

interface CategorizedRepos {
  failing: GitHubRepository[];
  noCi: GitHubRepository[];
  warnings: Array<{ name: string; url: string; message: string }>;
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
                statusCheckRollup {
                  state
                }
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
 * Categorize repositories by CI status
 */
function categorizeRepositories(repos: GitHubRepository[]): CategorizedRepos {
  const failing: GitHubRepository[] = [];
  const noCi: GitHubRepository[] = [];
  const warnings: Array<{ name: string; url: string; message: string }> = [];

  for (const repo of repos) {
    // Check if repo has no default branch
    if (!repo.defaultBranchRef) {
      warnings.push({
        name: repo.name,
        url: repo.url,
        message: `Repository "${repo.name}" has no default branch`,
      });
      continue;
    }

    const status = repo.defaultBranchRef.target.statusCheckRollup?.state;

    // Check for failing CI
    if (status === "FAILURE" || status === "ERROR") {
      failing.push(repo);
    }
    // Check for no CI configured
    else if (status === null) {
      noCi.push(repo);
    }
  }

  return { failing, noCi, warnings };
}

/**
 * Print results in plain text format
 */
function printResults(categories: CategorizedRepos, totalRepos: number): void {
  const { failing, noCi, warnings } = categories;

  // Print failing CI repositories
  if (failing.length > 0) {
    console.log("Repositories with failing CI:\n");
    for (const repo of failing) {
      console.log(`${repo.name} (${repo.url})`);
      const status = repo.defaultBranchRef?.target.statusCheckRollup?.state;
      console.log(`  Status: ${status}\n`);
    }
    console.log("---\n");
  } else {
    console.log("No repositories with failing CI\n");
    console.log("---\n");
  }

  // Print repositories without CI
  if (noCi.length > 0) {
    console.log("Repositories without CI (ignored):\n");
    for (const repo of noCi) {
      console.log(`${repo.name} (${repo.url})`);
    }
    console.log("\n---\n");
  }

  // Print warnings
  if (warnings.length > 0) {
    console.log("Warnings:\n");
    for (const warning of warnings) {
      console.log(warning.message);
    }
    console.log("\n---\n");
  }

  // Print summary
  console.log("Summary:");
  console.log(`- Failing CI: ${failing.length}`);
  console.log(`- No CI configured: ${noCi.length}`);
  console.log(`- Warnings: ${warnings.length}`);
  console.log(`- Total repositories checked: ${totalRepos}`);
}

/**
 * Main execution
 */
async function main() {
  try {
    const repositories = await fetchAllRepositories();
    const categories = categorizeRepositories(repositories);
    printResults(categories, repositories.length);
  } catch (error) {
    console.error("Unexpected error:");
    console.error(error);
    process.exit(1);
  }
}

// Run the script
main();
