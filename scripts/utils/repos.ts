/**
 * Repository fetching utilities
 */

import { executeGraphQL, type BaseGraphQLResponse } from "./graphql";
import { ORGANIZATION } from "./config";

export interface Repository {
  name: string;
  url: string;
  isArchived: boolean;
}

interface RepositoriesGraphQLResponse extends BaseGraphQLResponse {
  data: {
    organization: {
      repositories: {
        pageInfo: {
          hasNextPage: boolean;
          endCursor: string | null;
        };
        nodes: Repository[];
      };
    };
  };
}

const REPOS_QUERY = `
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
        }
      }
    }
  }
`;

/**
 * Fetch all repositories from the organization
 * @returns Array of all repositories
 */
export async function fetchAllRepositories(): Promise<Repository[]> {
  const repositories: Repository[] = [];
  let cursor: string | null = null;
  let hasNextPage = true;

  console.log(`Fetching repositories from ${ORGANIZATION} organization...`);

  while (hasNextPage) {
    const response = await executeGraphQL<RepositoriesGraphQLResponse>(
      REPOS_QUERY,
      { cursor }
    );
    const { pageInfo, nodes } = response.data.organization.repositories;

    repositories.push(...nodes);
    hasNextPage = pageInfo.hasNextPage;
    cursor = pageInfo.endCursor;
  }

  console.log(`Fetched ${repositories.length} repositories\n`);

  return repositories;
}

/**
 * Fetch only active (non-archived) repositories
 * @returns Array of active repositories
 */
export async function fetchActiveRepositories(): Promise<Repository[]> {
  const repos = await fetchAllRepositories();
  return repos.filter((r) => !r.isArchived);
}
