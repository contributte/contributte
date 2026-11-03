import { describe, expect, test } from "bun:test";
import { join } from "node:path";
import { readFileSync } from "node:fs";
import { evaluateReadme, loadRepositoryFacts } from "./evaluator";
import type { Finding, ReadmeProfile } from "./schema";

const fixtures = join(import.meta.dir, "fixtures");

function outcomes(profile: ReadmeProfile, name: string): Record<string, Finding["outcome"]> {
  const result = evaluateReadme(profile, loadRepositoryFacts(join(fixtures, name)));
  return Object.fromEntries(result.findings.map((item) => [item.id, item.outcome]));
}

describe("README evaluator", () => {
  test("accepts deterministic library evidence without inventing first-use proof", () => {
    expect(outcomes("library", "library-valid")).toMatchObject({
      "CM-ID-01": "pass",
      "CM-LK-01": "pass",
      "CM-CM-01": "pass",
      "LB-IN-01": "pass",
      "LB-FS-01": "unassessed",
    });
  });

  test("blocks a mismatched library install command and broken local link", () => {
    expect(outcomes("library", "library-invalid")).toMatchObject({
      "CM-ID-01": "fail",
      "CM-LK-01": "fail",
      "LB-IN-01": "fail",
    });
  });

  test("finds skeleton candidates but requires runtime evidence", () => {
    const result = evaluateReadme("skeleton", loadRepositoryFacts(join(fixtures, "skeleton-valid")));
    expect(Object.fromEntries(result.findings.map((item) => [item.id, item.outcome]))).toMatchObject({
      "SK-IN-01": "pass",
      "SK-FS-01": "unassessed",
      "CM-CM-01": "pass",
    });
    expect(result.status).toBe("incomplete");
    expect(result.quality.score).toBeNull();
  });

  test("blocks an inaccurate skeleton acquisition path", () => {
    expect(outcomes("skeleton", "skeleton-invalid")).toMatchObject({
      "SK-IN-01": "fail",
      "SK-FS-01": "unassessed",
      "CM-CM-01": "fail",
    });
  });

  test("accepts a prominent deprecated notice and explicit next action", () => {
    expect(outcomes("deprecated", "deprecated-valid")).toMatchObject({
      "DP-ST-01": "pass",
      "DP-NX-01": "pass",
    });
  });

  test("blocks installation before a vague late deprecation notice", () => {
    expect(outcomes("deprecated", "deprecated-invalid")).toMatchObject({
      "DP-ST-01": "fail",
      "DP-NX-01": "unassessed",
    });
  });

  test("does not treat deprecation in an image URL as a status notice", () => {
    expect(outcomes("deprecated", "deprecated-image-only")).toMatchObject({
      "DP-ST-01": "fail",
    });
  });

  test("does not treat prose about a make task as a target invocation", () => {
    expect(outcomes("skeleton", "make-prose")).toMatchObject({
      "CM-CM-01": "pass",
    });
  });

  test("ignores headings and links inside fenced examples", () => {
    expect(outcomes("library", "markdown-edge-cases")).toMatchObject({
      "CM-ID-01": "pass",
      "CM-ST-01": "pass",
      "CM-ST-02": "pass",
      "CM-LK-01": "pass",
    });
  });

  test("does not accept an installation command inside a Markdown example", () => {
    expect(outcomes("library", "command-in-markdown-example")).toMatchObject({
      "LB-IN-01": "fail",
    });
  });

  test("leaves anchor validation unassessed instead of claiming a pass", () => {
    expect(outcomes("library", "local-anchor")).toMatchObject({
      "CM-LK-01": "unassessed",
    });
  });

  test("leaves reference-style link validation unassessed", () => {
    expect(outcomes("library", "reference-link")).toMatchObject({
      "CM-LK-01": "unassessed",
    });
  });

  test("rejects a README path outside the repository", () => {
    expect(() => loadRepositoryFacts(join(fixtures, "library-valid"), "../library-invalid/README.md")).toThrow(
      "README path escapes repository root",
    );
  });

  test("does not accept a Composer package substring", () => {
    expect(outcomes("skeleton", "composer-substring")).toMatchObject({
      "SK-IN-01": "fail",
    });
  });

  test("does not accept a deprecation next-action heading without prose", () => {
    expect(outcomes("deprecated", "deprecated-empty-replacement")).toMatchObject({
      "DP-NX-01": "unassessed",
    });
  });

  test("machine results satisfy core JSON schema invariants", () => {
    const schema = JSON.parse(readFileSync(join(import.meta.dir, "result.schema.json"), "utf8")) as {
      properties: { findings: { items: { properties: { id: { pattern: string } } } } };
    };
    const result = evaluateReadme("library", loadRepositoryFacts(join(fixtures, "library-valid")));
    const idPattern = new RegExp(schema.properties.findings.items.properties.id.pattern);
    expect(result.findings.every((item) => idPattern.test(item.id))).toBeTrue();
    expect(result.findings.every((item) => item.evidence.every((item) => item.provisional))).toBeTrue();
    expect(result.summary).toEqual({
      passed: result.findings.filter((item) => item.outcome === "pass").length,
      failed: result.findings.filter((item) => item.outcome === "fail").length,
      unassessed: result.findings.filter((item) => item.outcome === "unassessed").length,
      notApplicable: result.findings.filter((item) => item.outcome === "not-applicable").length,
    });
  });

  test("reports results in stable rule order", () => {
    const result = evaluateReadme("library", loadRepositoryFacts(join(fixtures, "library-valid")));
    expect(result.findings.map((item) => item.id)).toEqual(
      [...result.findings.map((item) => item.id)].sort((left, right) => left.localeCompare(right)),
    );
  });
});
