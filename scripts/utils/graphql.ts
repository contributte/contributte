/**
 * Generic GraphQL query executor using gh CLI
 */

export interface GraphQLError {
  message: string;
}

export interface BaseGraphQLResponse {
  errors?: GraphQLError[];
}

/**
 * Execute a GraphQL query using gh CLI
 * @param query - The GraphQL query string
 * @param variables - Optional variables to pass to the query
 * @returns The parsed response of type T
 */
export async function executeGraphQL<T extends BaseGraphQLResponse>(
  query: string,
  variables?: Record<string, string | null>
): Promise<T> {
  const args = ["api", "graphql", "-f", `query=${query}`];

  if (variables) {
    for (const [key, value] of Object.entries(variables)) {
      if (value !== null) {
        args.push("-f", `${key}=${value}`);
      }
    }
  }

  const proc = Bun.spawn(["gh", ...args], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const stdout = await new Response(proc.stdout).text();
  const stderr = await new Response(proc.stderr).text();
  const exitCode = await proc.exited;

  if (exitCode !== 0) {
    console.error("Error executing gh CLI:");
    console.error(stderr);
    process.exit(1);
  }

  try {
    const response = JSON.parse(stdout) as T;

    if (response.errors) {
      console.error("GraphQL errors:");
      response.errors.forEach((err) => console.error(`  ${err.message}`));
      process.exit(1);
    }

    return response;
  } catch (error) {
    console.error("Error parsing JSON response from gh CLI");
    console.error("stdout:", stdout);
    console.error("stderr:", stderr);
    process.exit(1);
  }
}

/**
 * Execute a REST API call using gh CLI
 * @param endpoint - The API endpoint (e.g., "repos/owner/repo/compare/base...head")
 * @param jqFilter - Optional jq filter to apply
 * @returns The stdout as string, or null on error
 */
export async function executeRestAPI(
  endpoint: string,
  jqFilter?: string
): Promise<string | null> {
  const args = ["api", endpoint];
  if (jqFilter) {
    args.push("--jq", jqFilter);
  }

  const proc = Bun.spawn(["gh", ...args], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const stdout = await new Response(proc.stdout).text();
  const exitCode = await proc.exited;

  if (exitCode !== 0) {
    return null;
  }

  return stdout.trim();
}
