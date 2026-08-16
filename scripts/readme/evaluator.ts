import { existsSync, readFileSync } from "node:fs";
import { dirname, isAbsolute, join, normalize, relative, resolve } from "node:path";
import type {
  EvaluationResult,
  Evidence,
  Finding,
  ReadmeProfile,
  RepositoryFacts,
} from "./schema";

interface Heading {
  level: number;
  text: string;
  line: number;
}

interface Reference {
  target: string;
  line: number;
}

interface Image {
  alt: string;
  line: number;
}

function evidence(path: string, line: number | undefined, value: string): Evidence {
  return { provisional: true, type: "readme-span", path, line, value };
}

function repositoryEvidence(path: string, value: string): Evidence {
  return { provisional: true, type: "repository-fact", path, value };
}

function finding(
  id: string,
  severity: "gate" | "warning",
  outcome: Finding["outcome"],
  message: string,
  evidenceItems: Evidence[] = [],
  remediation?: string,
): Finding {
  return { id, severity, outcome, message, evidence: evidenceItems, remediation };
}

function linesOutsideFences(markdown: string): Array<{ text: string; line: number }> {
  const output: Array<{ text: string; line: number }> = [];
  let fence: { marker: string; length: number } | undefined;

  for (const [index, text] of markdown.split(/\r?\n/).entries()) {
    const match = text.match(/^\s*(`{3,}|~{3,})/);
    if (match) {
      const marker = match[1][0];
      if (!fence) {
        fence = { marker, length: match[1].length };
      } else if (fence.marker === marker && match[1].length >= fence.length) {
        fence = undefined;
      }
      continue;
    }

    if (!fence) output.push({ text, line: index + 1 });
  }

  return output;
}

function extractHeadings(markdown: string): Heading[] {
  const headings: Heading[] = [];
  const lines = linesOutsideFences(markdown);

  for (let index = 0; index < lines.length; index++) {
    const current = lines[index];
    const atx = current.text.match(/^\s{0,3}(#{1,6})\s+(.+?)\s*#*\s*$/);
    if (atx) {
      headings.push({ level: atx[1].length, text: atx[2], line: current.line });
      continue;
    }

    const html = current.text.match(/^\s*<h([1-6])(?:\s[^>]*)?>(.*?)<\/h\1>\s*$/i);
    if (html) {
      headings.push({
        level: Number(html[1]),
        text: html[2].replace(/<[^>]+>/g, "").trim(),
        line: current.line,
      });
      continue;
    }

    const next = lines[index + 1];
    if (current.text.trim() && next?.line === current.line + 1) {
      const setext = next.text.match(/^\s{0,3}(=+|-+)\s*$/);
      if (setext) {
        headings.push({
          level: setext[1][0] === "=" ? 1 : 2,
          text: current.text.trim(),
          line: current.line,
        });
        index++;
      }
    }
  }

  return headings;
}

function extractUntypedFences(markdown: string): number[] {
  const lines: number[] = [];
  let fence: { marker: string; length: number } | undefined;

  for (const [index, text] of markdown.split(/\r?\n/).entries()) {
    const match = text.match(/^\s*(`{3,}|~{3,})(.*)$/);
    if (!match) continue;
    const marker = match[1][0];
    if (!fence) {
      fence = { marker, length: match[1].length };
      if (!match[2].trim()) lines.push(index + 1);
    } else if (fence.marker === marker && match[1].length >= fence.length) {
      fence = undefined;
    }
  }

  return lines;
}

function extractReferences(markdown: string): Reference[] {
  const references: Reference[] = [];
  for (const { text, line } of linesOutsideFences(markdown)) {
    const patterns = [
      /!?\[[^\]]*\]\(([^)\s]+)(?:\s+["'][^"']*["'])?\)/g,
      /<(?:a|img)\b[^>]+(?:href|src)=["']([^"']+)["'][^>]*>/gi,
    ];
    for (const pattern of patterns) {
      for (const match of text.matchAll(pattern)) references.push({ target: match[1], line });
    }
  }
  return references;
}

function extractImages(markdown: string): Image[] {
  const images: Image[] = [];
  for (const { text, line } of linesOutsideFences(markdown)) {
    for (const match of text.matchAll(/!\[([^\]]*)\]\([^)]+\)/g)) {
      images.push({ alt: match[1].trim(), line });
    }
    for (const match of text.matchAll(/<img\b[^>]*>/gi)) {
      const alt = match[0].match(/\balt=["']([^"']*)["']/i)?.[1] ?? "";
      images.push({ alt: alt.trim(), line });
    }
  }
  return images;
}

function readerVisibleText(text: string): string {
  return text
    .replace(/!\[[^\]]*\]\([^)]+\)/g, " ")
    .replace(/<img\b[^>]*>/gi, " ")
    .replace(/<a\b[^>]*>|<\/a>/gi, " ")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/<[^>]+>/g, " ");
}

function lineContaining(markdown: string, pattern: RegExp): { line: number; text: string } | undefined {
  for (const [index, text] of markdown.split(/\r?\n/).entries()) {
    pattern.lastIndex = 0;
    if (pattern.test(text)) return { line: index + 1, text: text.trim() };
  }
  return undefined;
}

function commandContaining(markdown: string, pattern: RegExp): { line: number; text: string } | undefined {
  let fence: { marker: string; length: number; executable: boolean } | undefined;

  for (const [index, text] of markdown.split(/\r?\n/).entries()) {
    const fenceMatch = text.match(/^\s*(`{3,}|~{3,})(.*)$/);
    if (fenceMatch) {
      const marker = fenceMatch[1][0];
      if (!fence) {
        const language = fenceMatch[2].trim().split(/\s+/, 1)[0].toLowerCase();
        fence = {
          marker,
          length: fenceMatch[1].length,
          executable: !language || ["bash", "shell", "sh", "console"].includes(language),
        };
      } else if (fence.marker === marker && fenceMatch[1].length >= fence.length) {
        fence = undefined;
      }
      continue;
    }

    pattern.lastIndex = 0;
    if (fence?.executable && pattern.test(text)) return { line: index + 1, text: text.trim() };
    if (!fence) {
      for (const inline of text.matchAll(/`([^`]+)`/g)) {
        pattern.lastIndex = 0;
        if (pattern.test(inline[1])) return { line: index + 1, text: inline[1].trim() };
      }
    }
  }

  return undefined;
}

function evaluateShared(facts: RepositoryFacts): Finding[] {
  const findings: Finding[] = [];
  const headings = extractHeadings(facts.markdown);
  const titles = headings.filter((heading) => heading.level === 1);

  findings.push(
    titles.length === 1
      ? finding("CM-ID-01", "gate", "pass", "README has one visible H1.", [
          evidence(facts.readmePath, titles[0].line, titles[0].text),
        ])
      : finding(
          "CM-ID-01",
          "gate",
          "fail",
          `README has ${titles.length} visible H1 headings; expected exactly one.`,
          titles.map((title) => evidence(facts.readmePath, title.line, title.text)),
          "Add one textual project title and remove competing H1 headings.",
        ),
  );

  findings.push(
    finding("CM-OR-01", "gate", "unassessed", "Project purpose and audience require semantic review."),
    finding("CM-SF-01", "gate", "unassessed", "Secret exposure and dangerous defaults require security review."),
    finding("CM-CL-01", "gate", "unassessed", "Material claim consistency requires repository-grounded semantic review."),
  );

  const skipped = headings.find((heading, index) => index > 0 && heading.level > headings[index - 1].level + 1);
  findings.push(
    skipped
      ? finding("CM-ST-01", "warning", "fail", `Heading level jumps to H${skipped.level}.`, [
          evidence(facts.readmePath, skipped.line, skipped.text),
        ])
      : finding("CM-ST-01", "warning", "pass", "Heading levels are sequential."),
  );

  const untyped = extractUntypedFences(facts.markdown);
  findings.push(
    untyped.length
      ? finding(
          "CM-ST-02",
          "warning",
          "fail",
          `${untyped.length} fenced code block(s) have no language identifier.`,
          untyped.map((line) => evidence(facts.readmePath, line, "untyped fence")),
        )
      : finding("CM-ST-02", "warning", "pass", "All fenced code blocks identify their language."),
  );

  const broken: Evidence[] = [];
  const unsupported: Evidence[] = [];
  for (const { text, line } of linesOutsideFences(facts.markdown)) {
    if (/!?\[[^\]]+\]\[[^\]]*\]|^\s*\[[^\]]+\]:\s*\S+/.test(text)) {
      unsupported.push(evidence(facts.readmePath, line, text.trim()));
    }
  }
  for (const reference of extractReferences(facts.markdown)) {
    const target = reference.target.replace(/&amp;/g, "&");
    if (/^(?:[a-z][a-z0-9+.-]*:|\/\/)/i.test(target)) continue;
    if (target.startsWith("#")) {
      unsupported.push(evidence(facts.readmePath, reference.line, reference.target));
      continue;
    }
    let path: string;
    try {
      path = decodeURIComponent(target.split(/[?#]/, 1)[0]);
    } catch {
      unsupported.push(evidence(facts.readmePath, reference.line, reference.target));
      continue;
    }
    if (!path) continue;
    const resolved = resolve(dirname(join(facts.root, facts.readmePath)), path);
    const withinRoot = relative(facts.root, resolved);
    if (withinRoot.startsWith("..") || isAbsolute(withinRoot) || !existsSync(resolved)) {
      broken.push(evidence(facts.readmePath, reference.line, reference.target));
    } else if (target.includes("#")) {
      unsupported.push(evidence(facts.readmePath, reference.line, reference.target));
    }
  }
  findings.push(
    broken.length
      ? finding("CM-LK-01", "gate", "fail", `${broken.length} local reference(s) do not resolve.`, broken)
      : unsupported.length
        ? finding("CM-LK-01", "gate", "unassessed", "Some local references require unsupported anchor or URL-encoding validation.", unsupported)
      : finding("CM-LK-01", "gate", "pass", "Local references resolve.", [
          repositoryEvidence(facts.readmePath, "all detected local paths exist"),
        ]),
  );

  const weakImages = extractImages(facts.markdown).filter((image) =>
    !image.alt || /^(?:image|screenshot|badge|logo|todo|alt text|[^.]+\.(?:png|jpe?g|gif|svg|webp))$/i.test(image.alt),
  );
  findings.push(
    weakImages.length
      ? finding(
          "CM-AX-01",
          "warning",
          "fail",
          `${weakImages.length} image(s) need contextual alt-text review.`,
          weakImages.map((image) => evidence(facts.readmePath, image.line, image.alt || "empty alt")),
        )
      : finding("CM-AX-01", "warning", "pass", "Images have non-placeholder text alternatives."),
  );

  const makeReferences = new Set<string>();
  for (const { text } of linesOutsideFences(facts.markdown)) {
    for (const match of text.matchAll(/`make\s+([A-Za-z0-9][A-Za-z0-9_.-]*)`/g)) makeReferences.add(match[1]);
  }
  for (const block of facts.markdown.matchAll(/(?:^|\n)\s*(?:`{3,}|~{3,})(?:bash|shell|sh|console)\b[^\n]*\n([\s\S]*?)\n\s*(?:`{3,}|~{3,})/gi)) {
    for (const line of block[1].split(/\r?\n/)) {
      const match = line.trim().match(/^make\s+(?:-[A-Za-z]+\s+|[A-Za-z_][A-Za-z0-9_]*=\S+\s+)*([A-Za-z0-9][A-Za-z0-9_.-]*)/);
      if (match) makeReferences.add(match[1]);
    }
  }
  const unknownTargets = [...makeReferences].filter((target) => !facts.makeTargets.includes(target));
  findings.push(
    makeReferences.size === 0
      ? finding("CM-CM-01", "warning", "not-applicable", "README does not document Make targets.")
      : unknownTargets.length
        ? finding(
            "CM-CM-01",
            "warning",
            "fail",
            `Unknown Make target(s): ${unknownTargets.join(", ")}.`,
            [repositoryEvidence("Makefile", facts.makeTargets.join(", ") || "no targets")],
          )
        : finding("CM-CM-01", "warning", "pass", "Documented Make targets exist.", [
            repositoryEvidence("Makefile", [...makeReferences].join(", ")),
          ]),
  );

  return findings;
}

function evaluateLibrary(facts: RepositoryFacts): Finding[] {
  const install = commandContaining(facts.markdown, /\bcomposer\s+require(?:\s+--dev)?\s+([^\s`]+)/i);
  if (!facts.composerName) {
    return [
      finding(
        "LB-IN-01",
        "gate",
        "unassessed",
        "composer.json package name is unavailable; installation accuracy was not guessed.",
      ),
      finding(
        "LB-FS-01",
        "gate",
        "unassessed",
        "First-use correctness requires repository-grounded or executable evidence.",
      ),
    ];
  }

  const packagePattern = new RegExp(`\\bcomposer\\s+require(?:\\s+--dev)?\\s+${facts.composerName.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}(?:(?:[:=][^\\s]+)?(?:\\s|$|[\"']))`, "i");
  return [
    install && packagePattern.test(install.text)
      ? finding("LB-IN-01", "gate", "pass", "Composer installation matches composer.json.", [
          evidence(facts.readmePath, install.line, install.text),
          repositoryEvidence("composer.json#/name", facts.composerName),
        ])
      : finding(
          "LB-IN-01",
          "gate",
          "fail",
          `README does not install ${facts.composerName} with composer require.`,
          [repositoryEvidence("composer.json#/name", facts.composerName)],
          `Add a copyable composer require ${facts.composerName} command.`,
        ),
    finding(
      "LB-FS-01",
      "gate",
      "unassessed",
      "First-use correctness requires repository-grounded or executable evidence.",
    ),
    finding("LB-DM-01", "gate", "unassessed", "Dependency mode requires explicit package-policy evidence."),
    finding("LB-CP-01", "gate", "unassessed", "Compatibility claims require metadata, CI, and release-policy review."),
    finding("LB-EN-01", "gate", "unassessed", "Integration entrypoint completeness requires semantic review."),
  ];
}

function evaluateSkeleton(facts: RepositoryFacts): Finding[] {
  const createProject = commandContaining(facts.markdown, /\bcomposer\s+create-project\b/i);
  const expected = facts.composerName;
  let acquisition: Finding;
  if (!expected) {
    acquisition = finding(
      "SK-IN-01",
      "gate",
      "unassessed",
      "composer.json package name is unavailable; project acquisition accuracy was not guessed.",
    );
  } else if (
    createProject &&
    createProject.text
      .split(/\s+/)
      .map((token) => token.replace(/[:=].*$/, ""))
      .includes(expected)
  ) {
    acquisition = finding("SK-IN-01", "gate", "pass", "Project acquisition matches composer.json.", [
      evidence(facts.readmePath, createProject.line, createProject.text),
      repositoryEvidence("composer.json#/name", expected),
    ]);
  } else if (createProject) {
    acquisition = finding(
      "SK-IN-01",
      "gate",
      "fail",
      `README does not create ${expected} with composer create-project.`,
      [repositoryEvidence("composer.json#/name", expected)],
    );
  } else {
    acquisition = finding(
      "SK-IN-01",
      "gate",
      "unassessed",
      "No composer create-project command was found; clone or template acquisition may be valid.",
      [repositoryEvidence("composer.json#/name", expected)],
    );
  }

  const startup = commandContaining(facts.markdown, /\b(?:make\s+dev|composer\s+run\s+\S+|npm\s+run\s+(?:dev|start)|php\s+-S|docker\s+compose\s+up)\b/i);
  const proof = lineContaining(facts.markdown, /(?:https?:\/\/(?:localhost|127\.0\.0\.1):\d+|curl\s+https?:\/\/|expected (?:output|result|response)|returns?\s+[`"'{\[])/i);
  return [
    acquisition,
    startup && proof
      ? finding("SK-FS-01", "gate", "unassessed", "README contains startup and first-success candidates, but they were not executed.", [
          evidence(facts.readmePath, startup.line, startup.text),
          evidence(facts.readmePath, proof.line, proof.text),
        ])
      : finding(
          "SK-FS-01",
          "gate",
          "unassessed",
          "A complete first-success path could not be verified automatically.",
          [
            ...(startup ? [evidence(facts.readmePath, startup.line, startup.text)] : []),
            ...(proof ? [evidence(facts.readmePath, proof.line, proof.text)] : []),
          ],
          "Provide and execute one ordered path from setup through an observable result.",
        ),
    finding("SK-RQ-01", "gate", "unassessed", "Prerequisite completeness requires repository and task review."),
    finding("SK-CM-01", "gate", "unassessed", "Complete command ordering requires script and task review."),
    finding("SK-RT-01", "gate", "unassessed", "Runtime-route distinctions require semantic review."),
  ];
}

function evaluateDeprecated(facts: RepositoryFacts): Finding[] {
  let status: { line: number; text: string } | undefined;
  for (const { line, text } of linesOutsideFences(facts.markdown)) {
    const visible = readerVisibleText(text).trim();
    if (/^\s{0,3}#{1,6}\s/.test(text) || /^\s*<h[1-6]\b/i.test(text)) continue;
    if (/\b(?:deprecated|unmaintained|unsupported|archived|abandoned|no longer (?:being )?maintained)\b/i.test(visible)) {
      status = { line, text: visible };
      break;
    }
  }
  const install = commandContaining(facts.markdown, /\b(?:composer\s+(?:require|create-project)|npm\s+install)\b/i);
  const prominent = status && (!install || status.line < install.line) && status.line <= 20;
  let next: { line: number; text: string } | undefined;
  for (const { line, text } of linesOutsideFences(facts.markdown)) {
    const visible = readerVisibleText(text).trim();
    if (/^\s{0,3}#{1,6}\s/.test(text) || /^\s*<h[1-6]\b/i.test(text)) continue;
    if (/\b(?:replacement|migrat(?:e|ion)|no supported replacement|please use|use instead|do not use|do not adopt|pin(?:ned)? version|fork)\b/i.test(visible)) {
      next = { line, text: visible };
      break;
    }
  }
  return [
    prominent
      ? finding("DP-ST-01", "gate", "pass", "Unsupported status is prominent.", [
          evidence(facts.readmePath, status.line, status.text),
        ])
      : finding(
          "DP-ST-01",
          "gate",
          "fail",
          "Unsupported status is absent, late, or appears after installation guidance.",
          status ? [evidence(facts.readmePath, status.line, status.text)] : [],
        ),
    next
      ? finding("DP-NX-01", "gate", "pass", "README contains an explicit reader next action.", [
          evidence(facts.readmePath, next.line, next.text),
        ])
      : finding(
          "DP-NX-01",
          "gate",
          "unassessed",
          "A supported replacement, migration path, or explicit no-replacement decision was not verified.",
        ),
    finding("DP-SP-01", "gate", "unassessed", "Release, compatibility, and security posture require semantic review."),
    finding("DP-HS-01", "gate", "unassessed", "Historical-instruction boundaries require semantic review."),
  ];
}

export function loadRepositoryFacts(root: string, readme = "README.md"): RepositoryFacts {
  const repositoryRoot = normalize(resolve(root));
  const readmePath = normalize(readme);
  const absoluteReadme = resolve(repositoryRoot, readmePath);
  const relativeReadme = relative(repositoryRoot, absoluteReadme);
  if (relativeReadme.startsWith("..") || isAbsolute(relativeReadme)) {
    throw new Error(`README path escapes repository root: ${readme}`);
  }
  if (!existsSync(absoluteReadme)) throw new Error(`README not found: ${absoluteReadme}`);

  let composerName: string | undefined;
  const composerPath = join(repositoryRoot, "composer.json");
  if (existsSync(composerPath)) {
    const composer = JSON.parse(readFileSync(composerPath, "utf8")) as { name?: unknown };
    if (typeof composer.name === "string") composerName = composer.name;
  }

  const makefilePath = join(repositoryRoot, "Makefile");
  const makeTargets = existsSync(makefilePath)
    ? [...readFileSync(makefilePath, "utf8").matchAll(/^([A-Za-z0-9][A-Za-z0-9_.-]*):(?:\s|$)/gm)].map(
        (match) => match[1],
      )
    : [];

  return {
    root: repositoryRoot,
    readmePath,
    markdown: readFileSync(absoluteReadme, "utf8"),
    composerName,
    makeTargets,
  };
}

export function evaluateReadme(profile: ReadmeProfile, facts: RepositoryFacts): EvaluationResult {
  const findings = [
    ...evaluateShared(facts),
    ...(profile === "library"
      ? evaluateLibrary(facts)
      : profile === "skeleton"
        ? evaluateSkeleton(facts)
        : evaluateDeprecated(facts)),
  ].sort((left, right) => left.id.localeCompare(right.id));

  const count = (outcome: Finding["outcome"]) => findings.filter((item) => item.outcome === outcome).length;
  const gateFailed = findings.some((item) => item.severity === "gate" && item.outcome === "fail");

  return {
    schemaVersion: "1.0",
    standardVersion: "0.1-draft",
    profile,
    repositoryRoot: facts.root,
    readmePath: facts.readmePath,
    status: gateFailed ? "blocked" : "incomplete",
    summary: {
      passed: count("pass"),
      failed: count("fail"),
      unassessed: count("unassessed"),
      notApplicable: count("not-applicable"),
    },
    quality: {
      score: null,
      assessmentCoverage: 0,
      reason: "Quality scoring requires evidenced human or calibrated semantic review.",
    },
    findings,
  };
}
