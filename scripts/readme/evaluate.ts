#!/usr/bin/env bun

import { evaluateReadme, loadRepositoryFacts } from "./evaluator";
import { isReadmeProfile, README_PROFILES } from "./schema";

function usage(): string {
  return `Usage:
  bun scripts/readme/evaluate.ts --profile <${README_PROFILES.join("|")}> [repository]

Options:
  --profile <profile>  Required README profile
  --readme <path>      README path relative to repository (default: README.md)
  --format <format>    text or json (default: text)
  --help               Show this help`;
}

export function run(args: string[]): number {
  if (args.includes("--help")) {
    console.log(usage());
    return 0;
  }

  const values = new Map<string, string>();
  const positional: string[] = [];
  const known = new Set(["--profile", "--format", "--readme"]);
  for (let index = 0; index < args.length; index++) {
    const argument = args[index];
    if (argument.startsWith("--")) {
      if (!known.has(argument) || values.has(argument)) {
        console.error(`Unknown or duplicate option: ${argument}.`);
        return 2;
      }
      const value = args[index + 1];
      if (!value || value.startsWith("--")) {
        console.error(`Missing value for ${argument}.`);
        return 2;
      }
      values.set(argument, value);
      index++;
    } else {
      positional.push(argument);
    }
  }
  if (positional.length > 1) {
    console.error("Expected at most one repository path.");
    return 2;
  }

  const profileValue = values.get("--profile");
  const format = values.get("--format") ?? "text";
  const readme = values.get("--readme") ?? "README.md";
  const root = positional[0] ?? process.cwd();

  if (!profileValue || !isReadmeProfile(profileValue)) {
    console.error(`Invalid or missing --profile. Expected: ${README_PROFILES.join(", ")}.`);
    return 2;
  }
  if (format !== "text" && format !== "json") {
    console.error("Invalid --format. Expected: text or json.");
    return 2;
  }

  try {
    const result = evaluateReadme(profileValue, loadRepositoryFacts(root, readme));
    if (format === "json") {
      console.log(JSON.stringify(result, null, 2));
    } else {
      console.log(`README evaluation: ${result.readmePath}`);
      console.log(`Profile: ${result.profile}`);
      console.log(`Status: ${result.status}\n`);
      for (const item of result.findings) {
        console.log(`${item.outcome.toUpperCase()} ${item.id}: ${item.message}`);
      }
      console.log(
        `\nResult: ${result.summary.passed} passed, ${result.summary.failed} failed, ` +
          `${result.summary.unassessed} unassessed, ${result.summary.notApplicable} not applicable`,
      );
      console.log("Quality score: not calculated (human/semantic evidence required)");
    }

    return result.status === "blocked" ? 1 : 0;
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return 2;
  }
}

if (import.meta.main) process.exit(run(process.argv.slice(2)));
