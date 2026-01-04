# Release Command

Create a new GitHub release for a repository following the Contributte release format.

## Instructions

1. **Get reference releases**: Fetch the last 5 releases from `contributte/doctrine-dbal` to understand the release format pattern
2. **Analyze target repository**: Check the current releases and commits since the last release for the target repository
3. **Determine version**: Based on the changes, suggest an appropriate version number (major/minor/patch)
4. **Prepare release notes**: Format the release notes following the Contributte pattern:
   - "Bumped! [emoji]" header
   - Diff link comparing previous version to new version
   - Changes section (format: `- Description [commit-sha] (@author)`)
   - Maintenance section (optional)
5. **Create release**: Use `gh release create` to publish the release

## Categorization Rules

**Changes** - Code changes that affect functionality:
- New classes, methods, or features
- Bug fixes in code
- Type annotations and PHPDoc improvements
- PHP version upgrades (require PHP 8.x)
- Dependency upgrades (nette/*, symfony/*)
- Refactoring that changes code structure

**Maintenance** - Non-code changes:
- CI/GitHub Actions workflows
- Codestyle/Codesniffer updates
- PHPStan configuration (not code fixes)
- Tests (new tests, test refactoring)
- Documentation (README, docs)
- Makefile, .gitattributes, .editorconfig
- Composer dev dependencies only

## Release Notes Format

```
Bumped! [emoji]

Diff: https://github.com/contributte/[repo]/compare/[old-tag]...[new-tag]

Changes:
  - Change description [full-commit-sha] (@author)
  - Another change [full-commit-sha] (@author)

Maintenance:
  - CI/QA/docs change [full-commit-sha] (@author)
```

## Commands Used

```bash
# Get reference format
gh release list --repo contributte/doctrine-dbal --limit 5
gh release view --repo contributte/doctrine-dbal --json tagName,name,body

# Analyze target repo
gh api repos/contributte/[repo]/releases --jq '.[0] | {tag_name, name}'
gh api repos/contributte/[repo]/compare/[last-tag]...HEAD --jq '.commits | .[] | {sha, message: .commit.message | split("\n")[0], author: .author.login}'

# Create release
gh release create [version] --repo contributte/[repo] --title "[version]" --notes "[release-notes]"
```

## Usage

- `/release contributte/api` - Prepare and create a release for contributte/api
- `/release contributte/console v2.0.0` - Create release with specific version
- `/release https://github.com/contributte/forms` - Using full URL
