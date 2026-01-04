# Composer Outdated Command

List all outdated direct Composer dependencies and explain why they cannot be updated.

## Instructions

1. **Get outdated packages**: Run `composer outdated --direct --format=json` in the `dev/` directory to get all outdated direct dependencies

2. **Analyze blocking dependencies**: For each package with `latest-status: "update-possible"`, run `composer why-not <package> <latest-version>` to determine what's blocking the update

3. **Present results**: Output a markdown table with:
   - Package name
   - Current version
   - Latest version
   - Why it's outdated (blocking dependencies or version conflicts)

4. **Summarize root causes**: Group and list the root blockers (e.g., which packages are blocking multiple updates)

## Commands Used

```bash
# Get outdated packages as JSON
cd dev && composer outdated --direct --format=json

# Check why a specific package can't be updated
cd dev && composer why-not <package-name> <target-version>
```

## Output Format

```markdown
## Outdated Direct Dependencies

| Package | Current | Latest | Why Outdated |
|---------|---------|--------|--------------|
| contributte/bootstrap | v0.6.0 | v0.7.0 | `contributte/nella` requires `^0.6.0` |

## Root Causes

1. **`contributte/nella v0.2.0`** - Blocks 4 packages (bootstrap, latte, utils, di)
2. **Doctrine 2.x → 3.x migration** - Blocks nettrine/dbal, nettrine/orm, nettrine/fixtures
```
