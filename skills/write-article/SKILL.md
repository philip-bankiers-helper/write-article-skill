---
name: write-article
description: Idea to publishable technical article with all assets (spec, prose, diagrams, banner, title). Use when the user wants to write an article or technical blog post from an idea, repo, or notes; wants diagrams or a banner made for an article; or wants an existing draft reviewed and brought to the publishing bar.
---

# Write Article

Take a technical article from idea to a publishable bundle: spec, prose, diagrams, banner, title. Every asset final, everything reviewed end-to-end before the user sees it.

## Non-negotiables

Read `references/voice.md` before writing any prose. The voice canon is generative: applied from word one, never bolted on by rewriting a neutral draft afterward. The rewrite costs as much as a section of prose and the seams show.

Two asset lanes, chosen per diagram at spec time by one mechanical rule:

- **HTML lane** — the diagram carries verbatim technical text beyond short labels: code, IR, instruction names, exact numbers, file paths, tables of figures. Authored as fixed-size HTML in the Slate style, rendered to PNG. Rules: `references/html-diagrams.md`.
- **Image lane** — the diagram is conceptual or spatial, needs at most ~15 short verbatim labels, and contains no code. Generated with gpt-image-2 through codex. Rules: `references/image-craft.md`.

A raster model that typos one character of an instruction name torpedoes the article's credibility, and the failure is silent. When in doubt: HTML lane.

The banner is always image lane.

## Article folder

Everything for one article lives in one folder. If the host repo already has an `articles/` or `blog/` convention, follow it; otherwise:

```
articles/<slug>/
  spec.md
  article.md                      ← the deliverable
  assets/
    01-<name>.html                ← HTML lane source
    01-<name>.png                 ← rendered 2x PNG
    02-<name>-prompt.md           ← image lane prompt (kept for re-rolls)
    02-<name>.png
    banner-prompt.md
    banner.png
```

Assets are numbered in section order.

## Phases

Run the phases in order. Entering mid-stream is fine — a draft already exists, or the user only wants assets — start at the first incomplete phase. Never skip Ground or Review.

### 1. Intake

Establish four things, in writing: thesis (one sentence), audience (a specific person — "engineers who use Triton but haven't read its compiler", not "developers"), platform (X, Substack, or Medium; all are Markdown), and sources (repo paths, files, links to ground against). Ask only for what's missing.

Done when: all four are stated.

### 2. Ground

Read the actual code and sources. Never write about a system from docs or descriptions alone. Build a specifics inventory in `spec.md`: exact instruction names, real latency numbers, real file paths, real IR and pass names, each with where it came from. The article's credibility comes from specificity: `tcgen05.mma.async.sync`, not "a matrix multiply instruction".

Done when: every planned section can draw on at least one verbatim specific from the inventory.

### 3. Spec

Write `spec.md`: thesis, audience, platform; ~6 sections each with a one-line summary; per section, one diagram entry with (a) the one question the diagram answers, in one sentence, (b) its lane, by the mechanical rule, (c) the real content it will show. Choose one house look for all image-lane assets in this article (see `references/image-craft.md` — the look must pair deliberately with the dark Slate HTML theme; note the pairing choice in the spec).

**Spec gate:** show the user the spec and ask for edits or "go". Skip the gate only when the user's request already contained thesis and audience — and say you're skipping it.

Done when: the user approved, or the skip condition held.

### 4. Prose

Write `article.md` with the voice canon active from the first sentence. `##` for sections, `###` for subsections, never bold-as-heading. Place `**[INSERT IMAGE: <filename>]**` markers where diagrams go. Don't write diagrams yet: prose first, so each diagram serves what the text actually says.

Done when: every spec section is written and the only placeholders left are image markers.

### 5. Diagrams

For each diagram in spec order, by lane:

- **HTML lane:** author the fixed-size HTML per `references/html-diagrams.md`, render with `${CLAUDE_SKILL_DIR}/scripts/render-html.sh`, then read the rendered PNG and check it against the read-back checklist. Budget 2–3 passes; the third pass fixes the thing you can't see until the render.
- **Image lane:** author `NN-<name>-prompt.md` per `references/image-craft.md`, generate with `${CLAUDE_SKILL_DIR}/scripts/generate-image.sh`, read the PNG back against the gates. gpt-image-2 routinely adds text you never asked for (spec boxes, dimension callouts, captions), and that invented text is often wrong: in testing it labeled a model "LLaMA 2 7B" for a system that used `claude-opus-4-5`. Read every glyph in the image, not just your P0 strings. Any invented or wrong text fails read-back. One retry, and it's an edit, not a re-roll: append a Retry Delta to the prompt file and re-run the script with the previous PNG as the fourth argument, so the good composition survives.

Done when: every diagram in the spec has a final PNG that passed read-back.

### 6. Banner and title

Banner: image lane, 1920×768 (5:2), the article's house look, copy-light hero register. All meaningful content at least 10% in from the left and right edges and 20% in from top and bottom (for 1920×768: ~192px horizontal, ~155px vertical) — X crops the preview unpredictably, and the vertical crop bites hardest. Save prompt as `banner-prompt.md`, output as `banner.png`.

Title: written now, after the prose, so it echoes the real hook. Punchy and specific, not descriptive: "Your GPU Is Busy. CUTracer Tells You Why." — never "CUTracer: Debug, Profile, and Find Races". Offer the pick plus two alternates.

Done when: banner passed read-back and a title is chosen.

### 7. Review

Three passes, none optional, none a skim:

1. **Full read** of `article.md` top to bottom: accuracy against the grounding inventory, flow between sections, flow within sections, and the ending lands.
2. **Humanizer audit:** invoke the `humanizer` skill on the draft if it's installed; otherwise apply the checklist in `references/voice.md`. Where humanizer and the voice canon conflict, the canon wins.
3. **Publishing checklist**, every line:
   - `grep '—' article.md` finds no em dashes in prose (code blocks exempt)
   - no "This is not X; it is Y" constructions
   - no trailing summary paragraphs restating what was just said
   - every quoted string is verbatim from the grounding inventory (no reconstructed or paraphrased text wrapped in quotation marks; drop the quotes or make the quote exact). A fabricated "quote" is the fastest way to lose a specificity-driven piece.
   - all headings are `##` / `###`
   - every `**[INSERT IMAGE: …]**` marker names a file that exists in `assets/`, or is explicitly listed as pending with its prompt file saved
   - banner exists and passed read-back, or is listed as pending (prompt saved)
   - title is punchy, not descriptive
   - no `[repo-link]` or other placeholders remain

Done when: all three passes ran and every fix they surfaced is applied.

### 8. Package

Verify the bundle is complete and deliver it: the article, the title and alternates, and a per-file asset inventory. If codex was unavailable for any image-lane asset, its prompt file is saved and the asset is listed as **pending** — never silently downgraded to another medium.

Done when: the user has the bundle summary with the file list and any pending items.

## Dependencies

- **codex CLI**, authenticated, with built-in gpt-image-2 (image lane). Unavailable → prompts saved, assets marked pending, pipeline continues.
- **Google Chrome** (HTML lane rendering via headless screenshot).
- **humanizer skill** (review audit). Missing → voice.md checklist fallback, and say so.
