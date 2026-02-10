# Archive Repository Command

Archive a repository and update its README with comprehensive documentation following the Contributte archive format.

## Instructions

1. **Check archive template**: Read `.ai/archive-repo.md` for the exact README format
2. **Locate repository**: Find the local clone in `vcs/active/<repo-name>/` or `vcs/archive/<repo-name>/`
3. **Verify git remote**: Run `git remote -v` to confirm the correct GitHub repository
4. **Read current documentation**: Read README.md, `.docs/` directory, and composer.json
5. **ASK: Confirm details** using AskUserQuestion:
   - Repository name and composer package name
   - Whether there's a replacement package (Option A vs B)
   - If replacement exists, get the package name and URL
6. **ASK: Choose workflow** using AskUserQuestion:
   - PR workflow (create branch, push, create PR)
   - Direct workflow (commit to master, push, archive immediately)
7. **Rewrite README**: Follow the template from `.ai/archive-repo.md`:
   - Add deprecation badge with `?deprecated=1`
   - Add disclaimer section with `:warning:` emoji
   - Include Composer package info table
   - Consolidate `.docs/` content into README
   - Update Development section to past tense ("was maintained")
8. **Remove `.docs/` directory** after consolidating content
9. **Execute chosen workflow**:
   - PR: Create branch, commit, push, create PR
   - Direct: Commit to master, push, update description, archive
10. **ASK: Move directory** using AskUserQuestion:
    - Confirm moving from `vcs/active/` to `vcs/archive/`

## Key Decision Points (Use AskUserQuestion)

Always ask the user before proceeding with these decisions:

1. **Replacement package**: "Is there a replacement package users should migrate to?"
   - Options: No replacement / Specific package / Let user specify

2. **Workflow choice**: "Which workflow should we use?"
   - PR workflow (recommended for review)
   - Direct workflow (immediate archival)

3. **Final confirmation**: "Ready to archive the repository?"
   - Show summary of changes
   - Confirm before executing archive command

## Template Options

- **Option A**: With replacement package - includes migration path
- **Option B**: Without replacement package - simple deprecation notice
- **Option C**: For website/site projects - includes screenshot

## Commands Used

```bash
# Check remote
git remote -v

# Get current description
gh repo view <owner/repo> --json description -q '.description'

# PR Workflow
git checkout -b archive-style
git add -A && git commit -m "docs: convert to archive style"
git push -u origin archive-style
gh pr create --repo <owner/repo> --title "docs: convert to archive style" --body "..."

# Direct Workflow
git add -A && git commit -m "docs: convert to archive style"
git push origin master
gh repo edit <owner/repo> --description "[DISCONTINUED] <original>"
gh repo archive <owner/repo> --yes

# If repo is already archived
gh repo unarchive <owner/repo> --yes
# ... make changes ...
gh repo archive <owner/repo> --yes

# Move local directory
mv vcs/active/<repo-name> vcs/archive/
```

## Packagist URL Format

Always use the correct format with `/packages/`:
```markdown
| Composer | [`vendor/package`](https://packagist.org/packages/vendor/package) |
```

## Usage

- `/repo:archive contributte/doctrine-cache` - Archive with GitHub repo name
- `/repo:archive nettrine/cache` - Archive using composer package name
- `/repo:archive doctrine-cache` - Archive using local folder name
