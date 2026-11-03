export const README_PROFILES = ["library", "skeleton", "deprecated"] as const;

export type ReadmeProfile = (typeof README_PROFILES)[number];
export type Outcome = "pass" | "fail" | "unassessed" | "not-applicable";
export type Severity = "gate" | "warning";
export type EvidenceType = "readme-span" | "repository-fact";

export interface Evidence {
  provisional: true;
  type: EvidenceType;
  path: string;
  line?: number;
  value: string;
}

export interface Finding {
  id: string;
  severity: Severity;
  outcome: Outcome;
  message: string;
  evidence: Evidence[];
  remediation?: string;
}

export interface RepositoryFacts {
  root: string;
  readmePath: string;
  markdown: string;
  composerName?: string;
  makeTargets: string[];
}

export interface EvaluationResult {
  schemaVersion: "1.0";
  standardVersion: "0.1-draft";
  profile: ReadmeProfile;
  repositoryRoot: string;
  readmePath: string;
  status: "blocked" | "incomplete";
  summary: {
    passed: number;
    failed: number;
    unassessed: number;
    notApplicable: number;
  };
  quality: {
    score: null;
    assessmentCoverage: 0;
    reason: string;
  };
  findings: Finding[];
}

export function isReadmeProfile(value: string): value is ReadmeProfile {
  return README_PROFILES.includes(value as ReadmeProfile);
}
