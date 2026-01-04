/**
 * Configuration constants for scripts
 */

export const THRESHOLDS = {
  /** Days after which an issue is considered stale */
  staleIssue: 90,
  /** Days after which a PR is considered stale */
  stalePR: 30,
  /** Days after which a repo is considered stale */
  staleRepo: 90,
  /** Days after which a repo is considered neglected */
  neglectedRepo: 180,
} as const;

export const ORGANIZATION = "contributte";
