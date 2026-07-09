# write-article-skill

A Claude Code skill that takes a technical article from idea to a publishable bundle: spec, prose, diagrams, banner, and title, with every asset generated, rendered, and reviewed before you see it.

Two asset lanes, chosen per diagram by one mechanical rule:

- **HTML lane** — anything carrying verbatim code, IR, instruction names, or exact numbers is authored as fixed-size HTML in the dark Slate house style and rendered to a 2× PNG through headless Chrome. Pixel-exact text, always.
- **Image lane** — the banner and concept diagrams are generated with **gpt-image-2 through the codex CLI**, using a committed house look from a five-look aesthetic library so nothing ever lands on the generic neon-card attractor.

The pipeline has one human gate (spec approval, skipped when your request already contains thesis and audience) and ends with a mandatory three-pass review: full read-through, a [humanizer](https://github.com/blader/humanizer) audit, and a publishing checklist.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- [codex CLI](https://github.com/openai/codex), authenticated, with built-in gpt-image-2 image generation (comes with Codex plans) — image lane
- Google Chrome (or Chromium/Edge) — HTML diagram rendering
- [humanizer](https://github.com/blader/humanizer) skill, recommended: `npx skills add blader/humanizer` — review-phase voice audit

If codex is unavailable at run time the pipeline still completes: image prompts are saved and those assets are marked pending, never silently downgraded.

## Install

```bash
git clone <this-repo> write-article-skill
cd write-article-skill
cp -R .claude/skills/write-article ~/.claude/skills/
```

Or symlink instead of copy to make the clone canonical and updates a plain `git pull`:

```bash
ln -s "$(pwd)/.claude/skills/write-article" ~/.claude/skills/write-article
```

Start a new Claude Code session so the skill list refreshes.

## Verify

In a new session, ask: *"what are your article writing phases?"* — it should recite the eight phases (intake, ground, spec, prose, diagrams, banner and title, review, package).

## Use

```text
write an article about <idea>, grounded in <repo or files>, for <platform>
```

Give it thesis and audience up front and it skips the spec gate and runs straight through. Partial entry works too: "make the diagrams for this draft", "review this article", "redo the banner".

Everything for one article lands in a self-contained folder:

```
articles/<slug>/
  spec.md
  article.md                 ← the deliverable
  assets/
    01-<name>.html / .png    ← HTML lane (source + 2× render)
    02-<name>-prompt.md / .png  ← image lane (prompt kept for re-rolls)
    banner-prompt.md / banner.png
```

## Layout

```
.claude/skills/write-article/
  SKILL.md                   ← the pipeline: 8 phases, lane rule, gates
  references/
    voice.md                 ← generative voice canon (wins over humanizer on conflict)
    html-diagrams.md         ← Slate house style, render + read-back loop
    image-craft.md           ← gpt-image-2 craft system: 5 house looks, prompt format, lever policy
  scripts/
    render-html.sh           ← headless Chrome, 2× device scale
    generate-image.sh        ← codex exec render lane
```

## Updating

`git pull`, then re-copy (or nothing, if you symlinked).

## Supersedes

The three memory files this grew from — *Article Writing Process*, *Diagram Design Principles*, *Writing Voice Rules* — are superseded. If you installed them in a `~/.claude/projects/*/memory/` directory, remove them; this skill is canonical.
