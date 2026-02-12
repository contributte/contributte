#!/usr/bin/env bash
#
# Fetch GitHub releases from Contributte organization for a given month
#
# Usage: ./release-notes.sh YYYY/MM
# Example: ./release-notes.sh 2026/01
#
# Output format (pipe-separated, sorted by date):
# YYYY-MM-DDTHH:MM:SSZ|repo-name|tag-name|release-url
#

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 YYYY/MM" >&2
    echo "Example: $0 2026/01" >&2
    exit 1
fi

INPUT="$1"

# Parse and validate input format
if [[ ! "$INPUT" =~ ^[0-9]{4}/[0-9]{2}$ ]]; then
    echo "Error: Invalid format. Expected YYYY/MM (e.g., 2026/01)" >&2
    exit 1
fi

# Convert YYYY/MM to YYYY-MM for date filtering
YEAR_MONTH="${INPUT/\//-}"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed" >&2
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI. Run 'gh auth login'" >&2
    exit 1
fi

# Fetch all non-archived repositories
repos=$(gh repo list contributte --limit 500 --json name --no-archived -q '.[].name')

if [[ -z "$repos" ]]; then
    echo "Error: No repositories found in contributte organization" >&2
    exit 1
fi

# Collect releases for each repository
while IFS= read -r repo; do
    gh api "repos/contributte/$repo/releases" 2>/dev/null \
        | jq -r --arg repo "$repo" --arg ym "$YEAR_MONTH" \
            '.[] | select(.published_at | startswith($ym)) | "\(.published_at)|\($repo)|\(.tag_name)|\(.html_url)"' \
        2>/dev/null || true
done <<< "$repos" | sort
