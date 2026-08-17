import { describe, expect, test } from "bun:test";
import { extractCandidate, sha256 } from "./generator";

describe("README generation benchmark", () => {
  test("extracts a marked candidate and session ID from OpenCode JSON events", () => {
    const events = [
      JSON.stringify({ type: "step_start", sessionID: "ses_test" }),
      JSON.stringify({ type: "text", sessionID: "ses_test", part: { type: "text", text: "README_CANDIDATE_BEGIN\n# Package\n\nText.\nREADME_CANDIDATE_END" } }),
    ].join("\n");
    expect(extractCandidate(events)).toEqual({
      candidate: "# Package\n\nText.\n",
      candidateSha256: sha256("# Package\n\nText.\n"),
      sessionId: "ses_test",
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 },
    });
  });

  test("does not extract an unmarked response", () => {
    expect(extractCandidate(JSON.stringify({ type: "text", text: "# Package" }))).toEqual({
      candidate: undefined,
      candidateSha256: undefined,
      sessionId: undefined,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 },
    });
  });

  test("rejects duplicated candidates and text outside the markers", () => {
    const candidate = "README_CANDIDATE_BEGIN\n# Package\nREADME_CANDIDATE_END";
    expect(extractCandidate(JSON.stringify({ type: "text", text: `${candidate}\n${candidate}` })).candidate).toBeUndefined();
    expect(extractCandidate(JSON.stringify({ type: "text", text: `Preface\n${candidate}` })).candidate).toBeUndefined();
  });

  test("extracts only the final assistant response after progress text", () => {
    const events = [
      JSON.stringify({ type: "text", part: { type: "text", text: "Inspecting repository facts." } }),
      JSON.stringify({ type: "text", part: { type: "text", text: "README_CANDIDATE_BEGIN\n# Package\nREADME_CANDIDATE_END" } }),
    ].join("\n");
    expect(extractCandidate(events).candidate).toBe("# Package\n");
  });

  test("produces stable SHA-256 hashes", () => {
    expect(sha256("README\n")).toBe("57bb905d0f2ccecbb9d81d40daa17e1e05b109c833ddc766edb0b59561088f20");
  });
});
