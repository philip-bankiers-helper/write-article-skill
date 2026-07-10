# Image Lane: gpt-image-2 Through Codex

## Contract

You author the complete prompt file with full article context; codex is a thin render executor. `${CLAUDE_SKILL_DIR}/scripts/generate-image.sh` extracts the `## Final Generation Prompt` section of your prompt file and has codex's built-in gpt-image-2 render it. Nothing else in the file reaches the model.

gpt-image-2 renders exactly one thing: the literal text of the Final Generation Prompt. Any art direction that doesn't reach that string changes zero pixels. And a style-silent prompt is not neutral — the bare word "infographic" lands on the model's default attractor: flat neon-on-charcoal vector cards, evenly weighted boxes, and arrows. You beat the attractor by committing to a strong positive look, never by listing what to avoid.

Three rules:

1. **Craft survives into the Final Generation Prompt.** The final prompt is the deliverable, not a summary. Compress the content, never the craft.
2. **Every negative becomes a positive move.** Keep one short hard-exclude line for true contaminants (invented metrics, fake UI, duplicate text, watermark); express everything else as a committed look.
3. **Subject leads, craft modifies, text is protected.** The subject noun comes first; the medium is a trailing modifier of that same sentence; the exact P0 text is quoted and capped so a long style preamble can never crowd it out.

## One house look per article

Choose the look once, at spec time. The banner and every image-lane diagram in the article share it: a coherent article, not a mood board.

Pairing rule: these images sit in the same article as dark Slate HTML diagrams (`#0a0c10` ground). Blueprint Cyanotype and Cinematic Macro Still-Life sit naturally beside them. The light-stock looks (Swiss Editorial Knockout, Riso Two-Tone Editorial, Studio Hero Render) read as deliberate contrast — fine, but the spec must note the pairing as a choice, not an accident.

Register defaults:

- **Banner / hero** → Studio Hero Render for tactile key art, or Cinematic Macro Still-Life for one dramatic metaphor object. Copy-light: hook plus at most 1–3 short labels.
- **Concept diagram** → Blueprint Cyanotype for systems, architecture, and codebase maps; Riso Two-Tone Editorial for a single bold idea or a three-path split; Swiss Editorial Knockout for dense comparisons, taxonomies, and timelines.

## House Aesthetic Library

Five maximally distinct anchors. Each ships a paste-ready fragment; keep it near 40 words in the final prompt. Hexes, angles, and typeface names are adaptable defaults ("e.g." starting points), not verbatim mandates — tune them to the subject while keeping each look's load-bearing identity: its medium, its palette logic (one dominant, one neutral, one focal accent), its light and material, and its type character. Commit to exactly one; borrowing a single secondary element from another look is fine, blending two full recipes is not.

**1. Swiss Editorial Knockout** — dense infographics, comparisons, taxonomies, timelines, single-thesis posters. International-Typographic rigor so density reads as authoritative, not cluttered.

- Palette logic: warm off-white paper ground (e.g. `#FAF8F3`, dominant), near-black ink (e.g. `#16181D`) for type and hairline rules, exactly one saturated signal accent (e.g. Signal Red `#E5322B` or Ultramarine `#1B3CCB`) on the focal data and section numbers only.
- Type: grotesque-only (Helvetica-Now / Akzidenz character), three sizes maximum, ranged-left on a strict baseline grid; giant section numerals in the accent; one enormous headline carrying most of the message.
- Medium and light: flat offset-litho on uncoated stock, matte, deliberately shadowless; drama is structural (figure/ground, rule weight, white space); faint paper tooth in quiet areas; no cards, no arrows.
- Fragment: `A Swiss International-Typographic infographic as a flat offset-litho print on warm uncoated off-white stock (e.g. #FAF8F3); near-black grotesk type on a strict left-aligned baseline grid, hairline rules instead of cards, giant section numerals and one focal element in a single signal accent (e.g. Signal Red #E5322B); generous structural white space, flat shadowless print light, faint paper tooth.`

**2. Blueprint Cyanotype** — architecture visuals, codebase maps, system and dependency diagrams, layered stacks. The strongest replacement for the dark-SaaS card grid because it reads as draftsmanship, not a dashboard.

- Palette logic: deep Prussian/cyanotype blue ground (e.g. `#0E2A47`–`#1E466E`, dominant), chalk-white drafting linework (e.g. `#EAF2FA`), pale-cyan annotation (e.g. `#7FB7E8`), exactly one warm accent (e.g. oxidized-copper `#E2662F`) on the single most important node.
- Type: condensed engineering-stencil uppercase for labels plus true monospace for code strings and coordinates, so verbatim P0 reads as machine text; hierarchy by line weight.
- Medium and light: cyanotype contact print on cold-press cotton — paper-fiber tooth, faint chemical mottle, edge vignette; flat orthographic projection; the focal node lit a half-stop brighter; primary flow is the brightest, thickest line.
- Optional tail (drop first): corner registration marks, a lower-right drafting title block, dimension ticks, leader lines with tick terminators.
- Fragment: `A technical cyanotype blueprint contact print on cold-press cotton, deep Prussian-blue ground (e.g. #0E2A47-#1E466E) with fine chalk-white drafting linework and pale-cyan annotation; flat orthographic projection, primary flow the brightest thickest line, one oxidized-copper accent (e.g. #E2662F) on the critical node lit half a stop brighter; condensed engineering-stencil labels and monospace code strings, paper-fiber tooth and faint chemical mottle.`

**3. Riso Two-Tone Editorial** — concept explainers (especially three-step or three-path), single-metaphor big-idea frames, social teasers, blog heroes. Warm, hand-printed, unmistakably designed boldness.

- Palette logic: two true riso spot inks over warm stock (e.g. Fluorescent Pink `#FF4870` + Federal Blue `#2A3C8F`) overprinting to muddy aubergine (e.g. `#5B2E63`) only where the two ideas collide or converge, on warm newsprint cream (e.g. `#F4EFE1`). The overprint zone is the third color and marks the conceptual meeting point.
- Type: bold condensed grotesque (Druk / Founders character) for a three-to-five-word hook set large; monospace caption for one to three supporting labels; one ink per text channel; scale contrast of at least 4×.
- Medium and light: authentic risograph — visible halftone dot screens, deliberate 1–2mm misregistration so the pink fringe glows, grainy soy-ink texture, paper showing through the fills; "light" is the cream paper glowing through semi-transparent ink; depth comes from overprint density, not z-layers.
- Optional tail (drop first): a small printed registration mark in one corner; halftone dots coarsening toward the edges.
- Fragment: `An authentic two-color risograph print on warm cream newsprint (e.g. #F4EFE1): Fluorescent Pink (e.g. #FF4870) and Federal Blue (e.g. #2A3C8F) overprinting to aubergine only where the ideas converge; visible halftone dot screens, ~1.5mm misregistration so the pink fringe glows, grainy soy-ink texture, paper through the fills; one bold condensed-grotesque hook, monospace captions, depth from overprint not arrows.`

**4. Studio Hero Render** — blog heroes, launch and social key art, single-concept explainers where one idea should read as a tactile, beautifully-lit physical object. The keynote "hero object on seamless" treatment, with real directional light.

- Palette logic: warm off-white seamless sweep (e.g. `#F4F1EB`, dominant), hero object in a single desaturated clay hue (e.g. cobalt `#3A5CCC` / shadow `#28408F`), one warm rim accent (e.g. amber `#F2A83B`, under about 8% of frame); deepest shadow is ink-blue (e.g. `#1A2238`), never pure black.
- Type: humanist grotesque (GT-America / Soehne character), tight all-caps hook on the seamless (never on the object), one size jump of at least 3× to the label.
- Medium and light: matte 3D clay render, soft global illumination, one large soft key from upper-left around 35 degrees with a cool lower-right fill and a single warm rim; subtle subsurface, soft contact shadow and ambient occlusion, shallow depth of field; faint film grain over the whole frame to kill plastic cleanliness.
- Fragment: `A matte 3D clay-render hero object on the left third of a warm off-white seamless sweep (e.g. #F4F1EB), lit by one large soft key from upper-left ~35 degrees with a cool fill and a single warm amber rim (e.g. #F2A83B); fine matte micro-surface, soft contact shadow and ambient occlusion, shallow depth of field, deepest shadow ink-blue not black; a tight all-caps humanist-grotesque hook in the right negative space, faint film grain.`

**5. Cinematic Macro Still-Life** — high-drama hero key art for a launch or one big idea embodied as a single physical metaphor object (a router as a railway switch, a cache as a vault). The Economist / photographic-cover register: monumental, copy-light.

- Palette logic: near-black warm void (e.g. `#14110D`, dominant), hero object in burnished bronze/brass (e.g. `#B5853A` / shadow `#4A2E14`), one cold cyan practical accent (e.g. `#2FB6B0`) marking the "active" element; highlight rolloff to warm cream (e.g. `#EDE0C4`).
- Type: minimal high-contrast serif (Canela / Tiempos character) or sparse engraved caps set small in the dark negative space, like a gallery placard; the light shouts, the type whispers.
- Medium and light: photoreal macro render, 100mm-lens look, f/4 slim focus; single hard key spotlight raking from camera-left, almost no fill so the shadow side falls into the void; the cold practical kicks the opposite rim; physically-based brushed-metal surface, gentle filmic halation, fine sensor grain.
- Optional tail (drop first): dust motes in a visible light shaft; anisotropic streak highlights; embossed labels etched into the metal.
- Fragment: `A photoreal cinematic macro render of a single burnished-bronze object (e.g. #B5853A) embodying the concept, emerging from a near-black warm void (e.g. #14110D), lit by one hard focused key raking from camera-left with almost no fill; a small cold cyan practical (e.g. #2FB6B0) kicks the opposite rim; brushed-metal surface, filmic halation, fine grain, warm deep blacks, sparse serif title small in the dark negative space.`

## Typography and the label budget

gpt-image-2's superpower is large type; its weakness is many small text blocks, each of which raises garble risk.

- Lead with one commanding headline (3–7 words), set verbatim, in quotation marks, in ALL CAPS or a named weight.
- Priority tiers for exact text: **P0** must appear (keep the list small); **P1** if space allows; **P2** becomes icons, visual structure, paraphrase, or is omitted. A concept diagram wanting more than ~15 short P0+P1 labels belongs in the HTML lane instead.
- The hero headline and dense labels are mutually exclusive in one render: on label-dense images cap the headline near 10–12% of canvas height (about a 2× jump) so P0 labels stay large enough to render.
- Show relationships through one named mechanism — grid position, ink-channel assignment, leader lines with tick terminators, numbered reading-stations, or a physical bridge. Pick one and name it; never a field of identical arrows.
- Craft verbosity and label count share one budget: past ~5 supporting labels, drop the long signature-detail tail and carry only the ~40-word craft block.

## The prompt file

One `NN-<name>-prompt.md` (or `banner-prompt.md`) per asset, kept forever so re-rolls are one command:

1. **Artifact and placement** — which article section it serves, the one question it answers
2. **Viewer takeaway** — one sentence
3. **Crop and size** — from the lever policy below
4. **Message hierarchy** — ranked; main subject first
5. **Composition plan** — the house look applied to this subject, plus the one relationship mechanism
6. **Required text with priority** — P0 quoted verbatim with "render verbatim, exactly once, no extra characters, no duplicate text", then P1, P2
7. **Style, medium, and art direction** — the named look and its adapted craft block
8. **Hard excludes** — the one-line contaminant list
9. **Final Generation Prompt** — the deliverable: subject first, craft block (~35–45 words) folded into the same sentence, P0 quoted, hard excludes at the end. Name the crop in the text itself ("a wide 5:2 landscape banner", "a square frame"): the size argument reaches the tool as advisory, but crop language in the prompt survives every path
10. **Retry Delta** — appended only after a retry: what was cut, clarified, or changed

## Lever policy

- `quality high` for every text-bearing asset — the single biggest legibility lever. `medium` is acceptable only for sparse, large-type hero work. (In codex's built-in mode these levers are expressed in the render request text, not as tool arguments; the script's instruction already does this.)
- Size native to the crop. Tool limits: edges multiples of 16, max edge 3840, aspect ratio at most 3:1, total pixels 655,360–8,294,400. Craft ceiling: keep the max edge at 2048 — that's the reliable high-detail range; treat 4K as experimental. Defaults: **banner 1920×768** (exact 5:2), in-article landscape **1536×1024**, square **1024×1024**.
- No transparent backgrounds (rejected by gpt-image-2); generate on a flat solid color.
- Don't request `input_fidelity` (a no-op); rely on explicit "Preserve:" prompt text.
- Sensitive source content (credentials, internal hostnames, customer names, unreleased product names) stays out of prompts — generation leaves the machine.

## Generate, read back, retry once

```
${CLAUDE_SKILL_DIR}/scripts/generate-image.sh assets/02-<name>-prompt.md assets/02-<name>.png 1536x1024
```

The script extracts the PNG bytes from the codex session log — the image_gen tool's own recorded output — so a lazy executor can't substitute a stale or edited file; if the tool was never called, the script fails non-zero. Treat that as a generation failure (prompt saved, asset pending). The tool honors the requested aspect ratio but treats exact pixel dimensions as advisory; judge composition at read-back, not pixel counts.

Then **read the PNG** and gate it:

- main subject present; the look committed (not the neon-card attractor, not generic stock)
- every P0 string exact — check each glyph; a silent one-character typo is this lane's failure mode
- **no invented text.** gpt-image-2 loves to fill an infographic with authentic-looking detail you never wrote: spec boxes, dimension callouts, part numbers, captions. That text is frequently wrong on facts (in testing it labeled a model "LLaMA 2 7B" when the real system used `claude-opus-4-5`), and a wrong verbatim string in a technical diagram is worse than no diagram. Read every glyph the model added, not only the strings you specified. Any invented or wrong text fails the gate and goes to the edit-retry below to be stripped.
- no label soup, no invented claims or metrics, no duplicated text
- crop and register match the request; a focal idea reads within 2 seconds

One retry budget per asset, and it's a true edit, not a re-roll: append a `## Retry Delta` section to the prompt file — `Change:` the single flaw, with the exact corrected string if it's text; `Preserve:` layout, headline glyphs, palette, lighting, material and texture, and all other labels, restated in full — then re-run with the previous frame as the fourth argument:

```
${CLAUDE_SKILL_DIR}/scripts/generate-image.sh assets/02-<name>-prompt.md assets/02-<name>-v2.png 1536x1024 assets/02-<name>.png
```

The previous PNG is attached as the edit input, so the composition genuinely survives. Write the retry to a versioned filename, judge it at read-back, and keep whichever frame is better (rename the winner into place). If the retry still fails, keep the best frame and report the remaining flaw in Review.

## When codex is unavailable

Keep the finished prompt file, mark the asset **pending** in the Review checklist, and continue the pipeline. Never silently downgrade an image-lane asset to another medium.
