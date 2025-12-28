# Close Old Issue Command

Read the issue from the provided URL or repository, then close it with a polite comment explaining that the issue is too old and won't be addressed. Encourage the user to create a new issue if still relevant.

## Instructions

1. **Parse the input**: Extract the issue number and repository from the provided GitHub issue URL or repo context
2. **Fetch issue details**: Use `gh issue view <issue-number> --repo <repo>` to get the issue title and content
3. **Analyze the issue**: Read and understand what the issue is about
4. **Close with comment**: Use `gh issue close <issue-number> --repo <repo> --comment "<message>"` where the message should:
   - Address the specific content/topic of the issue
   - Politely explain that the issue is too old to be actionable
   - Encourage the user to create a new issue if the problem is still relevant
   - Keep a friendly and helpful tone

## Comment Template Structure

The comment should follow this pattern:
- Acknowledge what the issue was about (show you read it)
- Explain it's being closed due to age
- Invite them to reopen or create a new issue if still relevant

## Example

User provides: `https://github.com/contributte/console/issues/42` or just `contributte/console #42`

The command should:
1. Fetch issue details with `gh issue view 42 --repo contributte/console`
2. Read and understand the issue
3. Close with a relevant comment like:

```
Thank you for reporting this issue about [specific topic from the issue].

Unfortunately, this issue is quite old and we've decided not to address it at this time. Our codebase and priorities have evolved since this was originally filed.

However, if you're still experiencing this problem or believe this feature is still valuable, please feel free to create a new issue with updated context, or reopen this one with additional information about why it's still relevant.

We appreciate your understanding and contribution to the project!
```

## Usage

- `/issue:die https://github.com/owner/repo/issues/123`
- `/issue:die owner/repo #123`
- `/issue:die #123` (if repository context is clear)
