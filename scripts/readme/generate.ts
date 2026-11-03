#!/usr/bin/env bun

import { loadManifest, runGeneration } from "./generator";

function usage(): string {
  return "Usage: bun scripts/readme/generate.ts --manifest <manifest.json>";
}

export async function run(args: string[]): Promise<number> {
  if (args.includes("--help")) {
    console.log(usage());
    return 0;
  }
  if (args.length !== 2 || args[0] !== "--manifest" || !args[1]) {
    console.error(usage());
    return 2;
  }
  try {
    const results = await runGeneration(loadManifest(args[1]));
    for (const result of results) console.log(`${result.status}: ${result.directory}`);
    return results.every((result) => result.status === "generated") ? 0 : 1;
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return 2;
  }
}

if (import.meta.main) process.exit(await run(process.argv.slice(2)));
