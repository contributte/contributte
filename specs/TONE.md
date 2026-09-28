# Contributte Tone of Voice

This document describes how we write in Contributte repositories: `README.md`, `.docs/`, `AGENTS.md`, `PRD.md`,
`TECH.md`, `DESIGN.md`, commit messages, issues and pull requests. The layout of these files is described in
[DOCS.md](DOCS.md) and [AGENTS.md](AGENTS.md). This document covers the words inside them.

## Table of Contents

- [Rules](#rules)
- [Principles](#principles)
- [Person and Voice](#person-and-voice)
- [Sentences](#sentences)
- [Words to Avoid](#words-to-avoid)
- [Do and Don't](#do-and-dont)
- [Formatting](#formatting)
- [Callouts](#callouts)
- [README and Docs](#readme-and-docs)
- [Agent and Project Documents](#agent-and-project-documents)
- [Commit Messages](#commit-messages)
- [Issues and Pull Requests](#issues-and-pull-requests)
- [Before and After](#before-and-after)
- [Checklist](#checklist)

## Rules

- Write in plain English. Use articles: "the latest version", "a DI extension".
- The first sentence says what the thing is and what it does.
- Give facts instead of adjectives: numbers, names, behaviour.
- Say what the package does not do and what is dangerous.
- Address the reader as "you". Don't write "I", and don't write "our" about the team.
- Use active voice and present tense.
- Every code block is introduced by a short sentence that ends with a colon.
- No emoji in prose, headings or lists. The only exception is the fixed links line in the README header.
- No marketing words (see [Words to Avoid](#words-to-avoid)).
- Hints and warnings use GitHub alerts (see [Callouts](#callouts)).

## Principles

1. **Say what it is in the first sentence.** Name, category and job: "Contributte Console integrates Symfony
   Console into Nette Framework." The reader decides in ten seconds whether to keep reading.
2. **Start from the reader's problem.** One sentence on what is hard without the package, then what the package
   does about it.
3. **Show first, explain second.** Put the smallest working example as early as possible.
4. **Be concrete.** "Commands are registered automatically" beats "seamless integration". "Adds one service"
   beats "lightweight".
5. **Be honest about limits.** A plain "Don't use this in production" builds more trust than a badge.
6. **Keep it calm.** At most one exclamation mark per README, in the closing thank-you. A dry joke is fine once,
   never in installation, security or upgrade text.
7. **One voice for all repositories.** A reader who moves from `contributte/console` to `nettrine/orm` should not
   notice a change in style.

## Person and Voice

| Who | Use | Example |
|-----|-----|---------|
| The reader | "you" | "You can register more than one bus." |
| Walking through an example together | "let's", "we" | "Let's add a command that sends a newsletter:" |
| The organization | "Contributte" or "the Contributte team", third person | "Consider supporting the **contributte** development team." |
| The author | not used | – |

- Don't write "I have prepared…", "our documentation" or "give us a star".
- State behaviour as fact: "The extension registers every command it finds", not "All commands will be
  registered".

## Sentences

- Aim for 12 to 20 words per sentence. A very short sentence can land a point: "That's all."
- One idea per paragraph, two to four sentences per paragraph.
- Put the important word first: "`console.url` sets the host for links in CLI", not "In CLI, if you want links to
  have a host, you can set `console.url`".
- One rhetorical question may open a section ("How does the extension find commands?"). Don't stack them.
- Don't use em dashes. Use a colon, a comma or a new sentence.
- Write "PHP 8.2 or later" in prose, not "PHP 8.2+".

## Words to Avoid

| Avoid | Use instead |
|-------|-------------|
| awesome, great, super, amazing, ultimate, first class | Say what it does, with a fact |
| blazing fast, lightning fast, tiny, tiniest, lightweight | A number: "adds 0.2 ms per request", "one class" |
| seamless, effortless, painless, magic | Describe the step the reader no longer takes |
| simply, just, easily, obviously | Leave it out. If it were simple, the reader wouldn't be reading |
| powerful, robust, modern, cutting-edge | Name the feature |
| leverage, utilize | use |
| setup (as a verb) | set up. "Setup" is the noun |
| bridge, glue, wrapper (when it isn't one) | integrates X into Nette Framework |
| currently maintaining by | is maintained by |
| consider to support | consider supporting |
| latest version (without "the") | the latest version |
| please note that, it should be noted | Leave it out, or use a `NOTE` alert |
| click here | Link the words that name the target |

## Do and Don't

| Do | Don't |
|----|-------|
| "Datagrid is a data grid component for Nette Framework." | "You are looking at first class datagrid…" |
| "Requires PHP 8.2 or later and Nette 3.2." | Requirements only in badges |
| "Register the extension:" + code block | A code block with no lead-in |
| "Don't use it in production." | "Use with care" + emoji |
| "Set `console.url`, otherwise links have no host:" | "Important!!" |
| "See [compiler extensions](https://doc.nette.org/en/dependency-injection/extensions)." | "Click [here](…)." or a bare URL |
| `> [!TIP]` alert | `[**TIP**]`, bold "NOTE:", emoji |

## Formatting

- Inline code for every class, method, option, file, command and package: `ConsoleExtension`, `console.url`,
  `make tests`, `contributte/console`.
- Code blocks have a language: `php`, `neon`, `bash`, `json`, `latte`. NEON uses tabs.
- Commands must run when copied. Use real package names and no `...` inside commands.
- Show results in trailing comments (`// 'Acme'`) instead of a paragraph after the block.
- Explain configuration options with a comment in the NEON block, one comment per option.
- `.docs` headings use Title Case ("Shell Completion"). README headings use the fixed names from
  [DOCS.md](DOCS.md). No emoji, exclamation marks or links in headings.
- Link the exact page, not a home page.

## Callouts

Use GitHub alerts. Don't use bold labels, brackets or emoji for hints.

```markdown
> [!TIP]
> Take a look at more examples in [contributte/playground](https://github.com/contributte/playground).
```

| Alert | Use for |
|-------|---------|
| `> [!NOTE]` | Background the reader may skip |
| `> [!TIP]` | A better way to do something |
| `> [!IMPORTANT]` | Something the reader must do for it to work |
| `> [!WARNING]` | Something that breaks or loses data when ignored |
| `> [!CAUTION]` | Security risks |

- At most one alert per section. Two alerts in a row mean the text needs rewriting.
- The alert text is one to three sentences and says what to do.

## README and Docs

- The root README follows [DOCS.md](DOCS.md): header, a description of one to three sentences, Usage,
  Documentation, Versions, Development, footer.
- The description answers two questions: what it is and why you would want it.
- `## Usage` has the install command, one requirements sentence ("Requires PHP 8.2 or later.") and the smallest
  working example.
- In `.docs/README.md`, grow examples step by step: the minimal case, then "You can also…", then "Optionally…".
- A tutorial may tell a small story ("Let's build a command that sends a newsletter.") and follow it through.

## Agent and Project Documents

`AGENTS.md`, `PRD.md`, `TECH.md` and `DESIGN.md` are read by people and AI coding agents. The rules above apply,
with these additions:

- State facts first, then the rule that follows: "Commands are lazy. Don't add code that needs every command
  at boot."
- Give the reason in one clause: "…because tests assert on the message".
- Correct wrong assumptions directly: "`console.url` is used only in CLI mode, not in HTTP requests."
- Describe the current state. No plans, TODO lists or "we are working on…".
- Imperatives are short and absolute: "Never edit a released migration."
- The templates in these specs are outlines. `{...}` marks a placeholder; every fact comes from the repository,
  and a line that doesn't apply is deleted, not kept as a guess.
- Dates are real. A decision or screenshot whose date is unknown is marked (`(recorded)`, `undated`), never
  given an invented date.

## Commit Messages

```
{Area}: {what changed, imperative, lowercase}

Optional body that explains why. Wrap at 72 characters.
```

- The summary has at most 50 characters (without the pull request number GitHub adds).
- `{Area}` is the part of the repository: `DI`, `Console`, `Tests`, `Docs`, `CI`, `Composer`, `QA`.
- Use the imperative mood: "add", "fix", "drop", not "added", "fixes", "dropping".
- Match the style of the last 10 commits when the repository has its own (`git log -10 --oneline`).
- The body says why, not how. The diff shows how.
- Don't refer to chats, tickets in other systems or the state of your work ("wip", "final version", "as
  discussed").

Examples:

```
DI: resolve command name from #[AsCommand]
CI: inherit secrets in coverage workflow
Composer: require nette/di ^3.2
Docs: add shell completion example
```

## Issues and Pull Requests

- The title uses the commit summary style: `DI: command name is lost with lazy loading`.
- A bug report lists the package version, PHP version, the steps, what happened and what you expected, in that
  order. Paste errors as text in a code block, not as a screenshot.
- A pull request says what changed and why in two to four sentences, then how it was checked (`make qa`,
  `make tests`).
- Link the issue it closes: `Closes #123`.
- Replies are short and factual. Thank the author once. Don't apologise at length or promise dates.
- No greetings like "Hi guys", no urgency ("ASAP", "please merge quickly").

## Before and After

Real text from our repositories, rewritten in the house style.

**contributte/datagrid, description**

> Before: You are looking at first class datagrid for Nette Framework. Supported features: filtering, sorting,
> pagination, tree view, table view, translator and many others. Give us a star, it makes us so happy.

> After: Datagrid is a data grid component for Nette Framework. Give it a data source and it renders a table
> that your users can filter, sort and paginate, as a flat table or as a tree, with every label ready for
> translation.

**contributte/console, root README (no description today)**

> Before: (header, then) To install latest version of `contributte/console` use Composer.

> After: Contributte Console integrates Symfony Console into Nette Framework. Every command you register as a
> service is picked up automatically, so adding a command means writing one class.
>
> To install the latest version of `contributte/console`, use Composer:

**`.docs/README.md`, setup**

> Before: Install package using composer. Register prepared compiler extension in your `config.neon` file.

> After: Install the package with Composer:
> (code block)
> Register the extension in your `config.neon`:

**Footer**

> Before: Consider to support **contributte** development team. Also thank you for using this package.

> After: Consider supporting the **contributte** development team. Thank you for using this package.

**AGENTS.md bullet**

> Before: Be careful when changing the extension, commands can break.

> After: **Command names are resolved at compile time.** A command without a `console.command` tag or
> `#[AsCommand]` fails the container build, not the first run.

**Commit message**

> Before: `fixed stuff + updated readme`

> After: `DI: fail build for command without a name`, with the README change in a separate `Docs:` commit.

## Checklist

- [ ] The first sentence says what it is and what it does
- [ ] No words from [Words to Avoid](#words-to-avoid)
- [ ] "you" for the reader; no "I", "our" or "us"
- [ ] Every code block has a lead-in sentence ending with a colon
- [ ] Requirements are stated in one sentence
- [ ] Hints use GitHub alerts; no emoji outside the README links line
- [ ] Limits and dangers are stated plainly
- [ ] Commit summaries are `{Area}: {imperative}` and at most 50 characters
- [ ] Pull requests say what, why and how it was checked
