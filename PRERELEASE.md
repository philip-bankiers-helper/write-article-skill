# Pre-Release Notes — write-article

**Status:** private repo, shared for review and for a few dev friends to try. Not public yet.

This skill takes a technical article from idea to a finished bundle (spec, prose, diagrams, banner, title) inside Claude Code. It has one human gate (spec approval) and a mandatory three-pass review. Diagrams route to one of two lanes: pixel-exact HTML rendered through headless Chrome for anything with code or numbers, and gpt-image-2 (via the codex CLI) for the banner and concept visuals.

## Try it in ~5 minutes

### Prerequisites

- **Claude Code** (required).
- **python3** (required for the image lane).
- **Chrome / Chromium / Edge** for HTML diagram rendering. Set `CHROME_BIN=/path/to/chrome` if it isn't auto-detected.
- **codex CLI**, authenticated, with built-in gpt-image-2, for the image lane. Optional: without it, image assets are saved as prompts and flagged **pending**, and the rest of the pipeline still runs.
- Optional: the **humanizer** skill (`npx skills add blader/humanizer`) for the review-phase voice audit.

### Access (private repo)

Because the repo is private, a friend needs read access before either install method works. Add them as a collaborator:

```bash
gh repo add-collaborator philip-bankiers-helper/write-article-skill <their-github-username>
```

They then authenticate git/gh to GitHub as usual.

### Install — by copying the skill folder (simplest)

```bash
git clone https://github.com/philip-bankiers-helper/write-article-skill.git
cp -R write-article-skill/skills/write-article ~/.claude/skills/
```

Start a new Claude Code session so the skill list refreshes.

### Install — as a plugin

```text
/plugin marketplace add philip-bankiers-helper/write-article-skill
/plugin install write-article@write-article-skill
```

### Smoke test

1. New session, ask: **"what are your article writing phases?"** — it should recite the eight phases (intake, ground, spec, prose, diagrams, banner and title, review, package).
2. Give it a small real task with thesis + audience so it skips the spec gate and runs end to end, e.g.:
   *"Write a short Substack article about why `git bisect` beats print-debugging, for engineers who've never run it. Ground it in the `git bisect` man page."*
3. Watch it produce `articles/<slug>/` with `spec.md`, `article.md`, and rendered assets. If codex is set up, the banner comes from gpt-image-2; if not, you'll get a saved prompt and a "pending" note.

## What's verified vs. not

**Verified:**
- Full pipeline dry-run on a real article (grounding, spec gate, prose, both asset lanes, three-pass review).
- HTML render lane and gpt-image-2 image lane both run live on macOS, including the edit-retry that fixes a bad image without a full re-roll.
- The image lane extracts PNG bytes from the codex session log, so a misbehaving executor can't substitute a stale image.
- The python3 PNG-dimension fallback (the non-macOS path) returns correct results.

**Not yet verified:**
- The `/plugin marketplace add` round-trip from a clean machine. The manifests are valid JSON and follow the current docs, but the end-to-end plugin install hasn't been exercised. The folder-copy install is the safe path if the plugin flow misbehaves.
- Linux. The scripts are written to be portable (PATH-based Chrome detection, `CHROME_BIN` override, sips-or-python3 for dimensions), but they've only been run on macOS.

## Known gotchas for testers

- **gpt-image-2 invents text.** It will sometimes add authentic-looking but wrong labels to a diagram (it once wrote "LLaMA 2 7B" for a system that used `claude-opus-4-5`). The skill's read-back is built to catch this and re-run the image as an edit, but eyeball generated images anyway.
- **Chrome headless may not exit.** As of Chrome 149 the render can hang after writing the PNG; the script treats the file as the success signal and kills Chrome after a stable screenshot (30s cap).
- **Managed shell-execution policy.** Environments that disable skill shell execution can't run the two script-driven lanes.

## Feedback I'd love

- Does the spec gate fire when it should, and skip cleanly when your request already has a thesis and audience?
- Does the HTML-vs-image lane routing pick the right lane for your diagrams?
- Does the prose read like a person wrote it?
- Any install friction, especially the plugin path.

## Before making it public (maintainer checklist)

- [ ] Run the `/plugin marketplace add` round-trip from a clean checkout.
- [ ] Optionally personalize `LICENSE` (copyright holder) and `.claude-plugin/marketplace.json` (`owner.name`).
- [ ] Decide on public visibility; flip with `gh repo edit philip-bankiers-helper/write-article-skill --visibility public`.
- [ ] Consider a short demo GIF or a linked example article in the README.

## Remote / push reference

```bash
# One-time, from the repo root:
gh repo create philip-bankiers-helper/write-article-skill --private --source=. --remote=origin --push

# Thereafter:
git add -A && git commit -m "…" && git push
```

## Changelog

### 0.1.0
- Eight-phase pipeline: intake, ground, spec (one human gate), prose, diagrams, banner + title, three-pass review, package.
- Two asset lanes: dark "Slate" HTML diagrams rendered to 2× PNG via headless Chrome; gpt-image-2 banner and concept visuals via the codex CLI, with a five-look house-aesthetic library.
- Generative voice canon with a humanizer audit in review.
- Plugin and folder-copy install; scripts referenced via `${CLAUDE_SKILL_DIR}`.
- Portability: PATH-based Chrome detection, `CHROME_BIN` override, sips-or-python3 dimensions.
- Folded-in dry-run lessons: read-back rejects invented image text; review requires verbatim quotes from grounding.
