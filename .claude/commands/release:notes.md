# Release Notes Command

List all GitHub releases from the Contributte organization for a given month, formatted for Slack.

## Instructions

1. **Parse argument**: Extract year and month from the argument (e.g., `2025/12`) to get `YYYY-MM` format

2. **Get all repositories**: List all non-archived repositories in the `contributte` organization

3. **Collect releases**: For each repository, fetch releases via API and filter by the target month (match `published_at` starting with `YYYY-MM`)

4. **Sort releases**: Sort all collected releases by `published_at` date, oldest first

5. **Format output**: Generate Slack-compatible markdown:
   - Header: `🚀 Releases YYYY/MM ({count}x)`
   - Each release: `{n}. [contributte/{repo}] - [{tagName}]({url})`

## Commands

```bash
# List all repos in org (non-archived only)
gh repo list contributte --limit 500 --json name --no-archived -q '.[].name'

# Fetch releases for a repo via API (handles repos without releases gracefully)
gh api repos/contributte/{repo}/releases --jq '[.[] | select(.published_at | startswith("YYYY-MM")) | {repo: "{repo}", tagName: .tag_name, publishedAt: .published_at, url: .html_url}]'
```

## Output Format

Markdown with linked versions:

```
🚀 Releases 2025/12 (5x)
1. [contributte/api] - [v1.2.3](https://github.com/contributte/api/releases/tag/v1.2.3)
2. [contributte/forms] - [v2.0.0](https://github.com/contributte/forms/releases/tag/v2.0.0)
3. [contributte/console] - [v1.0.0](https://github.com/contributte/console/releases/tag/v1.0.0)
```

## Usage

- `/release:notes 2025/12` - List all December 2025 releases
- `/release:notes 2024/06` - List all June 2024 releases
