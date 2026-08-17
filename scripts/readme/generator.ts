import { cpSync, existsSync, lstatSync, mkdirSync, readFileSync, readdirSync, readlinkSync, rmSync, writeFileSync } from "node:fs";
import { basename, dirname, isAbsolute, join, relative, resolve } from "node:path";
import { createHash } from "node:crypto";
import { isReadmeProfile, type ReadmeProfile } from "./schema";

export interface GenerationManifest {
  schemaVersion: "1.0";
  id: string;
  repository: string;
  revision: string;
  readme: string;
  readmeSha256: string;
  profile: ReadmeProfile;
  prompt: string;
  promptVersion: string;
  model: string;
  variant: string;
  timeoutSeconds: number;
  runs: number;
  output: string;
}

export interface GenerationRunResult {
  run: number;
  directory: string;
  status: "generated" | "failed";
  exitCode: number;
  durationMs: number;
  candidateSha256?: string;
  candidateBytes?: number;
  sessionId?: string;
  usage: {
    inputTokens: number;
    outputTokens: number;
    reasoningTokens: number;
    cacheReadTokens: number;
    cacheWriteTokens: number;
    cost: number;
  };
  repositoryBeforeSha256: string;
  repositoryAfterSha256: string;
  repositoryMutated: boolean;
}

export function sha256(value: string | Uint8Array): string {
  return createHash("sha256").update(value).digest("hex");
}

export function loadManifest(path: string): GenerationManifest {
  const absolute = resolve(path);
  const value = JSON.parse(readFileSync(absolute, "utf8")) as Partial<GenerationManifest>;
  const required = [
    "schemaVersion",
    "id",
    "repository",
    "revision",
    "readme",
    "readmeSha256",
    "profile",
    "prompt",
    "promptVersion",
    "model",
    "variant",
    "timeoutSeconds",
    "runs",
    "output",
  ] as const;
  for (const key of required) {
    if (value[key] === undefined || value[key] === "") throw new Error(`Generation manifest is missing ${key}.`);
  }
  if (value.schemaVersion !== "1.0") throw new Error("Unsupported generation manifest schemaVersion.");
  if (!value.profile || !isReadmeProfile(value.profile)) throw new Error("Invalid generation profile.");
  if (!value.revision?.match(/^[0-9a-f]{40}$/)) throw new Error("Generation revision must be a full Git SHA.");
  if (!value.readmeSha256?.match(/^[0-9a-f]{64}$/)) throw new Error("Generation README hash must be SHA-256.");
  if (!Number.isInteger(value.runs) || value.runs! < 1 || value.runs! > 10) throw new Error("Generation runs must be 1..10.");
  if (!Number.isInteger(value.timeoutSeconds) || value.timeoutSeconds! < 30 || value.timeoutSeconds! > 3600) {
    throw new Error("Generation timeoutSeconds must be 30..3600.");
  }

  const base = dirname(absolute);
  return {
    ...value,
    repository: resolve(value.repository!),
    prompt: isAbsolute(value.prompt!) ? value.prompt! : resolve(base, "..", "..", "..", value.prompt!),
    output: resolve(value.output!),
  } as GenerationManifest;
}

export function parseEvents(events: string): Pick<GenerationRunResult, "candidateSha256" | "sessionId" | "usage"> & { candidate?: string } {
  const texts: string[] = [];
  let sessionId: string | undefined;
  const usage = { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 };
  for (const line of events.split(/\r?\n/)) {
    if (!line.trim()) continue;
    const event: unknown = JSON.parse(line);
    if (!event || typeof event !== "object") continue;
    const record = event as Record<string, unknown>;
    if (typeof record.sessionID === "string") sessionId = record.sessionID;
    const part = record.part && typeof record.part === "object" ? (record.part as Record<string, unknown>) : record;
    if (part.type === "text" && typeof part.text === "string") texts.push(part.text);
    if (part.type === "step-finish") {
      const tokens = part.tokens && typeof part.tokens === "object" ? (part.tokens as Record<string, unknown>) : {};
      const cache = tokens.cache && typeof tokens.cache === "object" ? (tokens.cache as Record<string, unknown>) : {};
      usage.inputTokens += typeof tokens.input === "number" ? tokens.input : 0;
      usage.outputTokens += typeof tokens.output === "number" ? tokens.output : 0;
      usage.reasoningTokens += typeof tokens.reasoning === "number" ? tokens.reasoning : 0;
      usage.cacheReadTokens += typeof cache.read === "number" ? cache.read : 0;
      usage.cacheWriteTokens += typeof cache.write === "number" ? cache.write : 0;
      usage.cost += typeof part.cost === "number" ? part.cost : 0;
    }
  }

  const combined = (texts.at(-1) ?? "").replaceAll("\r\n", "\n");
  const matches = [...combined.matchAll(/README_CANDIDATE_BEGIN\s*\n([\s\S]*?)\nREADME_CANDIDATE_END/g)];
  const candidate = matches.length === 1 && combined.replace(matches[0][0], "").trim() === "" && matches[0][1].trim()
    ? `${matches[0][1].trimEnd()}\n`
    : undefined;
  return { candidate, candidateSha256: candidate ? sha256(candidate) : undefined, sessionId, usage };
}

export const extractCandidate = parseEvents;

export function repositoryTreeSha256(root: string): string {
  const inventory: string[] = [];
  const visit = (directory: string): void => {
    for (const name of readdirSync(directory).sort()) {
      const absolute = join(directory, name);
      const path = relative(root, absolute).replaceAll("\\", "/");
      const stat = lstatSync(absolute);
      if (stat.isDirectory()) {
        inventory.push(`d\0${path}\0${stat.mode & 0o7777}\n`);
        visit(absolute);
      } else if (stat.isSymbolicLink()) {
        inventory.push(`l\0${path}\0${stat.mode & 0o7777}\0${readlinkSync(absolute)}\n`);
      } else {
        inventory.push(`f\0${path}\0${stat.mode & 0o7777}\0${sha256(readFileSync(absolute))}\n`);
      }
    }
  };
  visit(root);
  return sha256(inventory.join(""));
}

function git(repository: string, args: string[]): string {
  const result = Bun.spawnSync(["git", ...args], { cwd: repository, stdout: "pipe", stderr: "pipe" });
  if (result.exitCode !== 0) throw new Error(result.stderr.toString().trim() || `git ${args.join(" ")} failed`);
  return result.stdout.toString().trim();
}

export function validateManifest(manifest: GenerationManifest): void {
  if (!existsSync(manifest.repository)) throw new Error(`Repository does not exist: ${manifest.repository}`);
  const revision = git(manifest.repository, ["rev-parse", "HEAD"]);
  if (revision !== manifest.revision) throw new Error(`Revision mismatch: expected ${manifest.revision}, got ${revision}.`);
  const changes = git(manifest.repository, ["status", "--porcelain", "--untracked-files=all"]);
  if (changes) throw new Error("Generation repository must have a clean worktree, including untracked files.");
  const readme = resolve(manifest.repository, manifest.readme);
  const within = relative(manifest.repository, readme);
  if (within.startsWith("..") || isAbsolute(within)) throw new Error("README path escapes repository root.");
  if (!existsSync(readme)) throw new Error(`README does not exist: ${readme}`);
  const hash = sha256(readFileSync(readme));
  if (hash !== manifest.readmeSha256) throw new Error(`README hash mismatch: expected ${manifest.readmeSha256}, got ${hash}.`);
  if (!existsSync(manifest.prompt)) throw new Error(`Prompt does not exist: ${manifest.prompt}`);
  const outputFromRepository = relative(manifest.repository, manifest.output);
  const repositoryFromOutput = relative(manifest.output, manifest.repository);
  if ((!outputFromRepository.startsWith("..") && !isAbsolute(outputFromRepository)) ||
      (!repositoryFromOutput.startsWith("..") && !isAbsolute(repositoryFromOutput))) {
    throw new Error("Generation output and source repository must not contain each other.");
  }
}

export async function runGeneration(manifest: GenerationManifest): Promise<GenerationRunResult[]> {
  validateManifest(manifest);
  mkdirSync(manifest.output, { recursive: true });
  const promptTemplate = readFileSync(manifest.prompt, "utf8");
  const versionResult = Bun.spawnSync(["opencode", "--version"], { stdout: "pipe", stderr: "pipe" });
  if (versionResult.exitCode !== 0) throw new Error("Could not determine OpenCode version.");
  const opencodeVersion = versionResult.stdout.toString().trim();
  const results: GenerationRunResult[] = [];

  for (let run = 1; run <= manifest.runs; run++) {
    const directory = join(manifest.output, `${manifest.id}-run-${String(run).padStart(2, "0")}`);
    if (existsSync(directory)) throw new Error(`Generation run already exists: ${directory}`);
    mkdirSync(directory, { recursive: true });
    const worktree = join(directory, "source-worktree");
    const repository = join(directory, "repository");
    git(manifest.repository, ["worktree", "add", "--detach", worktree, manifest.revision]);
    try {
      const readmeHash = sha256(readFileSync(resolve(worktree, manifest.readme)));
      if (readmeHash !== manifest.readmeSha256) throw new Error(`Pinned worktree README hash mismatch: expected ${manifest.readmeSha256}, got ${readmeHash}.`);
      cpSync(worktree, repository, {
        recursive: true,
        filter: (source) => basename(source) !== ".git",
      });
    } finally {
      git(manifest.repository, ["worktree", "remove", "--force", worktree]);
      rmSync(worktree, { recursive: true, force: true });
    }
    const prompt = promptTemplate.replaceAll("{{PROFILE}}", manifest.profile);
    writeFileSync(join(directory, "prompt.md"), prompt);
    const repositoryBeforeSha256 = repositoryTreeSha256(repository);
    writeFileSync(join(directory, "manifest.json"), JSON.stringify({
      ...manifest,
      opencodeVersion,
      promptSha256: sha256(prompt),
      run,
      repositoryBeforeSha256,
    }, null, 2) + "\n");

    const started = performance.now();
    const process = Bun.spawn(
      [
        "opencode",
        "run",
        "--pure",
        "--format",
        "json",
        "--model",
        manifest.model,
        "--variant",
        manifest.variant,
        "--dir",
        repository,
        prompt,
      ],
      { cwd: repository, stdout: "pipe", stderr: "pipe", env: { ...Bun.env, GITHUB_TOKEN: "", GH_TOKEN: "" } },
    );
    const timeout = setTimeout(() => process.kill(), manifest.timeoutSeconds * 1000);
    const [stdout, stderr, exitCode] = await Promise.all([
      new Response(process.stdout).text(),
      new Response(process.stderr).text(),
      process.exited,
    ]);
    clearTimeout(timeout);
    const durationMs = Math.round(performance.now() - started);
    writeFileSync(join(directory, "events.jsonl"), stdout);
    writeFileSync(join(directory, "stderr.log"), stderr);
    const repositoryAfterSha256 = repositoryTreeSha256(repository);
    const repositoryMutated = repositoryAfterSha256 !== repositoryBeforeSha256;
    let extracted: ReturnType<typeof parseEvents>;
    try {
      extracted = parseEvents(stdout);
    } catch {
      extracted = {
        candidateSha256: undefined,
        sessionId: undefined,
        usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 },
      };
    }
    if (extracted.candidate) writeFileSync(join(directory, "candidate.md"), extracted.candidate);
    const result: GenerationRunResult = {
      run,
      directory,
      status: exitCode === 0 && extracted.candidate && !repositoryMutated ? "generated" : "failed",
      exitCode,
      durationMs,
      candidateSha256: extracted.candidateSha256,
      candidateBytes: extracted.candidate ? Buffer.byteLength(extracted.candidate) : undefined,
      sessionId: extracted.sessionId,
      usage: extracted.usage,
      repositoryBeforeSha256,
      repositoryAfterSha256,
      repositoryMutated,
    };
    writeFileSync(join(directory, "result.json"), JSON.stringify(result, null, 2) + "\n");
    results.push(result);
  }

  return results;
}
