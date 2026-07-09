# Voice Canon

Concrete rules for human-sounding technical prose. Validated the hard way: the first complete draft of the Triton/TLX article had correct content and read like AI output, and the rewrite cost as much as a section of prose. These rules are generative — apply them from word one, never as an editing pass.

## The rules

**No em dashes in prose.** The single strongest AI signal. Replace with:

- a period and a new sentence: "X — Y" → "X. Y."
- a colon before a list: "naming something — a buffer, a barrier — that…" → "naming something: a buffer, a barrier, that…"
- a comma for an aside: "on AMD — µTLX replaces…" → "on AMD, µTLX replaces…"
- parentheses for an inline clarification

Exempt: code comments, image label separators.

**No "This is not X; it is Y" constructions.** Textbook-philosophy voice. Say what it is: "These aren't gaps in Triton's implementation. They're outside its abstraction boundary by design."

**No stiff three-beat parallel triplets.** "You get productivity, control, and composability" — especially closing a section. Vary the rhythm. One strong sentence beats three parallel weak ones.

**No formal academic openings.** Not "In this section, we explore…", not "It is important to understand that…". Start with the fact or the action.

**No trailing summary sentences.** Don't end a paragraph by restating it. The reader can read. Cut it.

**Use contractions.** "isn't", "doesn't", "you're", "it's", "they're". Contraction-free prose is the AI default; contractions sound like a person.

**Vary sentence length.** Mix short punchy sentences with longer ones. "Load. Sync. Compute. Sync." works because longer sentences surround it. Three long sentences in a row drone.

**Lead with the fact.** Not "The reason X happens is because Y." Write "Y causes X," or "X happens because Y." Front-load the information.

**Make the "so what" implicit.** Never "This matters because…". If the setup is right, the reader sees why it matters. If you have to explain why something matters, the setup is weak — fix the setup.

## Precedence

The humanizer skill runs as an independent audit in the Review phase. It's the net, not the canon: where one of its patterns conflicts with a rule here, this file wins. Its additional detections (significance inflation, vague attribution, hedging, sycophantic tone, generic conclusions, AI vocabulary like "landscape" and "testament") are consistent with the canon — take them.

## Review checklist (fallback when humanizer is unavailable)

Per paragraph: em dashes? trailing summary? triplet close? academic opener? missing contractions? three long sentences in a row? Then whole-piece: does any paragraph explain why something matters instead of showing it?
