# Archive Repository Template

This template should be used when archiving a Contributte repository.

## Steps

1. Add deprecation badge to the top of README.md (add `?deprecated=1` to heatbadger URL)
2. Add disclaimer section after the header badges
3. Keep original documentation below disclaimer (optional but recommended)
4. Update "Development" section text to past tense
5. Use GitHub CLI to archive the repository
6. Point users to the replacement package (if applicable)

## README.md Template

### Option A: With Replacement Package (Preferred)

```markdown
![](https://heatbadger.now.sh/github/readme/contributte/{{REPO_NAME}}/?deprecated=1)

<p align=center>
    <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
    <a href="https://bit.ly/cttfo"><img src="https://badgen.net/badge/support/forum/yellow"></a>
    <a href="https://contributte.org/partners.html"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

<p align=center>
    Website 🚀 <a href="https://contributte.org">contributte.org</a> | Contact 👨🏻‍💻 <a href="https://f3l1x.io">f3l1x.io</a> | Twitter 🐦 <a href="https://twitter.com/contributte">@contributte</a>
</p>

## Disclaimer

| :warning: | This project is no longer being maintained. Please use [{{REPLACEMENT_PACKAGE}}]({{REPLACEMENT_URL}}).|
|---|---|

| Composer | [`{{COMPOSER_PACKAGE}}`](https://packagist.org/packages/{{COMPOSER_PACKAGE}}) |
|---| --- |
| Version | ![](https://badgen.net/packagist/v/{{COMPOSER_PACKAGE}}) |
| PHP | ![](https://badgen.net/packagist/php/{{COMPOSER_PACKAGE}}) |
| License | ![](https://badgen.net/github/license/contributte/{{REPO_NAME}}) |

[OPTIONAL: Keep original documentation sections like Usage, Versions, etc.]

## Development

This package was maintain by these authors.

<a href="https://github.com/f3l1x">
  <img width="80" height="80" src="https://avatars2.githubusercontent.com/u/538058?v=3&s=80">
</a>

-----

Consider to [support](https://contributte.org/partners.html) **contributte** development team.
Also thank you for being used this package.
```

### Option B: Without Replacement Package

```markdown
![](https://heatbadger.now.sh/github/readme/contributte/{{REPO_NAME}}/?deprecated=1)

<p align=center>
    <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
    <a href="https://bit.ly/cttfo"><img src="https://badgen.net/badge/support/forum/yellow"></a>
    <a href="https://contributte.org/partners.html"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

<p align=center>
    Website 🚀 <a href="https://contributte.org">contributte.org</a> | Contact 👨🏻‍💻 <a href="https://f3l1x.io">f3l1x.io</a> | Twitter 🐦 <a href="https://twitter.com/contributte">@contributte</a>
</p>

## Disclaimer

| :warning: | This project is no longer being maintained.
|---|---|

| Composer | [`{{COMPOSER_PACKAGE}}`](https://packagist.org/packages/{{COMPOSER_PACKAGE}}) |
|---|------------------------------------------------------------|
| Version | ![](https://badgen.net/packagist/v/{{COMPOSER_PACKAGE}})      |
| PHP | ![](https://badgen.net/packagist/php/{{COMPOSER_PACKAGE}})    |
| License | ![](https://badgen.net/github/license/contributte/{{REPO_NAME}})   |

[OPTIONAL: Keep original documentation sections like Usage, Versions, etc.]

## Development

This package was maintained by these authors.

<a href="https://github.com/f3l1x">
  <img width="80" height="80" src="https://avatars2.githubusercontent.com/u/538058?v=3&s=80">
</a>

-----

Consider to [support](https://contributte.org/partners.html) **contributte** development team.
Also thank you for using this package.
```

### Option C: For Website/Site Projects

```markdown
![](https://heatbadger.now.sh/github/readme/contributte/{{REPO_NAME}}/?deprecated=1)

<p align=center>
  <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
  <a href="https://bit.ly/cttfo"><img src="https://badgen.net/badge/support/forum/yellow"></a>
  <a href="https://contributte.org/partners.html"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

<p align=center>
Website 🚀 <a href="https://contributte.org">contributte.org</a> | Contact 👨🏻‍💻 <a href="https://f3l1x.io">f3l1x.io</a> | Twitter 🐦 <a href="https://twitter.com/contributte">@contributte</a>
</p>

<p align=center>
    <img src="https://api.microlink.io/?url={{SITE_URL}}&overlay.browser=light&screenshot=true&meta=false&embed=screenshot.url">
</p>

## Disclaimer

| :warning: | This project is no longer being maintained. Please use [{{REPLACEMENT_NAME}}]({{REPLACEMENT_URL}}).
|---| --- |

[OPTIONAL: Keep original documentation sections like Usage, Installation, etc.]

## Development

See [how to contribute](https://contributte.org/contributing.html) to this package.

This package is currently maintaining by these authors.

<a href="https://github.com/f3l1x">
  <img width="80" height="80" src="https://avatars2.githubusercontent.com/u/538058?v=3&s=80">
</a>

-----

Consider to [support](https://contributte.org/partners.html) **contributte** development team.
Also thank you for using this package.
```

## Placeholders to Replace

- `{{REPO_NAME}}` - Repository name (e.g., ntdb, model, apitte-core)
- `{{COMPOSER_PACKAGE}}` - Full composer package name (e.g., minetro/ntdb, contributte/model)
- `{{REPLACEMENT_PACKAGE}}` - Name of the replacement package (e.g., contributte/database)
- `{{REPLACEMENT_URL}}` - GitHub URL or website to replacement (e.g., https://github.com/contributte/database or http://blog.nette.org)
- `{{REPLACEMENT_NAME}}` - Display name for replacement (e.g., blog.nette.org, componette-site)
- `{{SITE_URL}}` - URL for site screenshot (only for site projects)

## GitHub CLI Commands

### With Replacement Package

```bash
# Archive the repository
gh repo archive contributte/{{REPO_NAME}} --yes

# Update repository description to indicate it's archived
gh repo edit contributte/{{REPO_NAME}} --description "⚠️ ARCHIVED - Please use {{REPLACEMENT_PACKAGE}} instead"
```

### Without Replacement Package

```bash
# Archive the repository
gh repo archive contributte/{{REPO_NAME}} --yes

# Update repository description to indicate it's archived
gh repo edit contributte/{{REPO_NAME}} --description "⚠️ ARCHIVED - No longer maintained"
```

## Common Patterns Observed

### Heatbadger Badge URLs
- Standard: `https://heatbadger.now.sh/github/readme/contributte/{{REPO_NAME}}/?deprecated=1`
- Alternative: `https://heatbadger.vercel.app/github/readme/contributte/{{REPO_NAME}}/?deprecated=1`
- Active (for reference): `https://heatbadger.now.sh/github/readme/contributte/{{REPO_NAME}}/`

### Disclaimer Message Variations
- With package: "This project is no longer being maintained. Please use [package](url)."
- With website: "This project is no longer being maintained. Please use [site.com](url)."
- Without replacement: "This project is no longer being maintained."

### Development Section Text
- **Archived**: "This package **was maintain** by these authors." or "This package **was maintained** by these authors."
- **Active** (for reference): "This package is currently maintaining by these authors."

### Table Formatting Variations
Both formats are used:
```markdown
# Format 1 (most common)
| :warning: | Message text |
|---|---|

# Format 2 (also valid)
| :warning: | Message text |
|---| --- |
```

## Notes

- **Always** add `?deprecated=1` to the heatbadger URL
- Keep all original documentation intact below the disclaimer (recommended for user reference)
- The deprecation badge at the top provides immediate visual feedback
- The disclaimer table format is prominent and clear with warning emoji
- Always provide a migration path to the replacement package when available
- Ensure the replacement package is properly documented and ready before archiving
- Change "is currently maintaining" to "was maintain" or "was maintained" in Development section
- For Composer packages, always include the package info table with badges
- For site/web projects, optionally include a screenshot using microlink.io
- Some archived repos keep full documentation, some keep minimal - decide based on usefulness
