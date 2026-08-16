# Contributte Deprecated Repository README Standard

## Profiles

[Overview](readme-standard.md) | [Library](readme-library-standard.md) | [Skeleton](readme-skeleton-standard.md) | [Deprecated](readme-deprecated-standard.md) | [Evaluation](spec-driven-docs.md)

## Scope

This standard applies to libraries and projects that are archived, abandoned, superseded, or no longer supported. Their README is a truthful maintenance notice, not an attempt to preserve a current onboarding path.

Use this profile before archiving a repository and whenever a repository's current README implies active support that no longer exists.

## Writing style

Write concise, factual developer-facing English. Prefer concrete subjects, verbs, package names, versions, support terms, and migration outcomes. Preserve accurate project terminology, product names, and established public wording; this standard does not require stylistic rewriting when existing language is clearer or more precise.

In this standard, "factual" means verifiable from the repository, released package, or documented support policy. "Concrete" means naming the relevant replacement, version, support status, or action. "Clear" means a reader can identify the maintenance state and next action without promotional or implied claims.

Prefer: `No supported replacement is available.`

Avoid: `This project is old and should probably not be used.`

Examples illustrate the required information; they are not mandatory wording. Keep project-specific terminology where it is accurate and understandable.

## Required information

A deprecated README MUST begin with a visible H1 and an unambiguous status notice near the top. The notice MUST state:

1. That the repository is deprecated, abandoned, archived, or unsupported.
2. Whether security fixes, compatibility fixes, or releases are still provided.
3. The recommended replacement, successor, or migration path when one exists.
4. What users should do when no supported replacement exists.

Use this default structure:

```md
# Package Name

> [!WARNING]
> This package is no longer maintained. No releases, compatibility fixes, or
> security updates are planned.

## Replacement

## Existing installations

## Historical documentation

## License
```

Use an appropriate GitHub alert level:

- `WARNING` for a maintained migration path or a package that should not be selected for new work.
- `CAUTION` when the package has known security, data-loss, or operational risk.
- `NOTE` only for a planned future deprecation that does not yet change support.

## Replacement and migration

When a successor exists, link directly to its canonical repository, package, or migration guide. State whether APIs/configuration are compatible, require migration, or are unrelated. Do not claim drop-in compatibility without verification.

When no replacement exists, state `No supported replacement is available.` Link to stable historical release documentation only when it remains useful for existing installations. Do not direct users to generic organization pages, issue trackers, or unmaintained forks as if they were supported replacements.

## Existing installations

Do not remove historical installation or configuration information needed to operate an existing deployment unless an owned archived documentation location retains it. Clearly separate it from new-project guidance:

```md
## Existing installations

The following instructions are retained for deployments already using this package.
They are not supported for new projects.
```

When known, provide an actionable maintenance boundary for existing deployments: the final supported release or version, the retained documentation location, and a statement that the material is historical and receives no support, compatibility fixes, or security updates. This does not promise a migration guide or ongoing support.

Remove or label stale requirements, badges, CI claims, demo links, social channels, and screenshots that suggest active maintenance. Never leave a current-looking `composer require` path at the top without the deprecation warning.

## Security and ownership

Do not promise security support unless a maintainer has explicitly committed to it. If the repository is abandoned because of a security concern, state the safe action first and use a `CAUTION` alert.

Keep the original license and attribution. Do not add real secrets, private contact details, or unsupported operational guarantees.

## Archival checklist

- [ ] README status notice is visible before installation or usage material.
- [ ] H1 and GitHub alert level accurately communicate the maintenance and risk status.
- [ ] Support and security posture is explicit and truthful.
- [ ] Replacement or absence of replacement is clear.
- [ ] Existing-installation documentation is separated from new-project guidance.
- [ ] Stale badges, demos, and contact/support links do not imply active maintenance.
- [ ] Local historical links resolve and Markdown renders correctly on GitHub.
- [ ] Historical material is clearly retained only for existing installations; license and attribution remain intact.
- [ ] Repository description, topics, and GitHub archive state agree with the README when repository administration is in scope.
