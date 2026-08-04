# Install write-article

A [Claude Code](https://claude.com/claude-code) skill. Two ways in; the folder copy is the safe one.

## 1. Install

### By copying the skill folder (recommended)

```bash
git clone https://github.com/philip-bankiers-helper/write-article-skill.git
cp -R write-article-skill/skills/write-article ~/.claude/skills/
```

Or symlink instead, so updates are a plain `git pull`:

```bash
ln -s "$(pwd)/write-article-skill/skills/write-article" ~/.claude/skills/write-article
```

### As a plugin

```text
/plugin marketplace add philip-bankiers-helper/write-article-skill
/plugin install write-article@write-article-skill
```

Either way, start a **new** Claude Code session afterwards — the skill list is read at startup.

## 2. Check the prerequisites

| Tool | Needed for | If missing |
| --- | --- | --- |
| Claude Code | runs the skill | required |
| `python3` | image lane (extracts PNG bytes, reads dimensions) | required for image lane |
| Chrome / Chromium / Edge | rendering HTML diagrams | HTML lane fails; set `CHROME_BIN=/path/to/chrome` if not auto-detected |
| [codex CLI](https://github.com/openai/codex), authenticated, with gpt-image-2 | banner + concept images | prompts are saved, assets flagged **pending**, rest of the pipeline still runs |
| [humanizer](https://github.com/blader/humanizer) skill (`npx skills add blader/humanizer`) | review-phase voice audit | falls back to the built-in `voice.md` checklist |

Only Claude Code is hard-required. Without codex you still get the full article and HTML diagrams; image assets come back as prompts marked pending.

## 3. Verify

New session, ask:

> what are your article writing phases?

It should recite eight: intake, ground, spec, prose, diagrams, banner and title, review, package.

## 4. First real run

Give it a thesis and an audience up front and it skips the spec approval gate and runs end to end:

> Write a short Substack article about why `git bisect` beats print-debugging, for engineers who've never run it. Ground it in the `git bisect` man page.

Output lands in **your** project, never in this repo:

```
articles/<slug>/
  spec.md
  article.md          ← the deliverable
  assets/             ← rendered diagrams, banner, and the prompts behind them
```

Partial entry works too: "make the diagrams for this draft", "review this article", "redo the banner".

## Known gotchas

- **gpt-image-2 invents text.** It will occasionally add authentic-looking but wrong labels to a diagram (it once wrote "LLaMA 2 7B" for a system that used `claude-opus-4-5`). The skill reads every image back and re-runs it as an edit when it catches this — but eyeball generated images anyway.
- **Headless Chrome may not exit.** As of Chrome 149 the render can hang after writing the PNG. The script treats the written file as the success signal and kills Chrome after a stable screenshot, 30s cap.
- **Managed shell-execution policy.** Environments that disable skill shell execution can't run either script-driven lane.
- **Platform.** Fully exercised on macOS. The scripts are written portably (PATH-based Chrome detection, `CHROME_BIN` override, `sips`-or-`python3` for dimensions) but haven't been run on Linux.

## Permissions

The skill shells out to the codex CLI and headless Chrome through its two `scripts/`, and reads/writes files in your project. Claude Code prompts the first time. To cut the prompts, allow those invocations in your project or user settings.

## Troubleshooting

- **"codex CLI not found" / assets pending** — install and authenticate the codex CLI; confirm `codex exec` works and your plan includes gpt-image-2.
- **"no Chrome/Chromium/Edge found"** — install a Chromium-family browser or set `CHROME_BIN=/path/to/chrome`.
- **Skill doesn't show up** — confirm `~/.claude/skills/write-article/SKILL.md` exists, then restart Claude Code.
- **`git clone` returns "Repository not found"** — the repo is private; you need read access on the GitHub account you're authenticated as.

Design notes — the two asset lanes, the voice canon, the house-look library — are in [README.md](README.md) and the `references/` files inside the skill.
