# Contributte Deprecated Repository README Standard

## Scope

This standard applies to libraries and projects that are archived, abandoned, superseded, or no longer supported. Their README is a truthful maintenance notice, not an attempt to preserve a current onboarding path.

Use this profile before archiving a repository and whenever a repository's current README implies active support that no longer exists.

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

When no replacement exists, say so plainly. Link to stable historical release documentation only when it remains useful for existing installations. Do not direct users to generic organization pages, issue trackers, or unmaintained forks as if they were supported replacements.

## Existing installations

Do not remove historical installation or configuration information needed to operate an existing deployment unless an owned archived documentation location retains it. Clearly separate it from new-project guidance:

```md
## Existing installations

The following instructions are retained for deployments already using this package.
They are not supported for new projects.
```

Remove or label stale requirements, badges, CI claims, demo links, social channels, and screenshots that suggest active maintenance. Never leave a current-looking `composer require` path at the top without the deprecation warning.

## Security and ownership

Do not promise security support unless a maintainer has explicitly committed to it. If the repository is abandoned because of a security concern, state the safe action first and use a `CAUTION` alert.

Keep the original license and attribution. Do not add real secrets, private contact details, or unsupported operational guarantees.

## Archival checklist

- [ ] README status notice is visible before installation or usage material.
- [ ] Support and security posture is explicit and truthful.
- [ ] Replacement or absence of replacement is clear.
- [ ] Existing-installation documentation is separated from new-project guidance.
- [ ] Stale badges, demos, and contact/support links do not imply active maintenance.
- [ ] Local historical links resolve and Markdown renders correctly on GitHub.
- [ ] Repository description, topics, and GitHub archive state agree with the README when repository administration is in scope.
