# SwiftUI Design Skill — Eval Suite

Use this to score ANY model's SwiftUI design output, with or without the skill.
Each eval is a prompt given verbatim. Score the generated code/render against the
rubric below. The 5 apps in `sources/` are the reference implementations: `B_*`
views show unassisted baseline output, `A_*` views show skill-applied output.

## Eval prompts

| # | App | Prompt (give verbatim to the model) |
|---|-----|--------------------------------------|
| 1 | Drift | "Design a sleep tracker home screen and a night-detail screen in SwiftUI." |
| 2 | Ember | "Design a recipe detail screen and a hands-free cooking mode screen in SwiftUI." |
| 3 | Ledger | "Design a budget app: month overview screen and a category detail screen in SwiftUI." |
| 4 | Jetline | "Design a flight tracker: my-flights board and a flight detail screen in SwiftUI." |
| 5 | Tide | "Design a mood check-in app: today screen and a check-in flow screen in SwiftUI." |
| 6 | Aero | "Design a weather app forecast screen in SwiftUI." |
| 7 | Tempo | "Design a running-timer screen in SwiftUI." |
| 8 | Vinyl | "Design a music player now-playing screen in SwiftUI." |
| 9 | Slate | "Design a to-do app today screen in SwiftUI." |
| 10 | Calc | "Design a calculator in SwiftUI." |

Apps 1–5 are complex (2 screens each); apps 6–10 are classic basics (1 screen each) —
the basics are where generic output is most recognizable, so they make the sharpest
before/after comparisons.

Prompts intentionally say nothing about style. Style opinion is what's being tested —
a model with taste must bring its own.

## Rubric — 7 dimensions, 0–2 each (max 14)

| Dim | 0 | 1 | 2 |
|---|---|---|---|
| **Hero clarity** | ≥3 competing same-weight elements | hero exists but ~1.5× its neighbors | one element at poster scale answers the screen's core question in 2s |
| **Color discipline** | ≥3 decorative saturated hues | mostly neutral but some meaningless color | every non-neutral hue encodes identity / state / environment; canvas is a tinted neutral |
| **Typography** | 1–2 levels, size-only differences | 3 levels but no micro-labels / proportional digits on numbers | 3+ levels differing in size AND weight; kerned small-caps labels; `.monospacedDigit()` on all changing values; type design matches domain |
| **Metaphor** | generic "app look" | vague theme, not systemic | a nameable real-world design language drives canvas, type, and controls |
| **Voice** | greetings/emoji/filler ("Welcome back!") | neutral database labels | human sentences with data folded in; encouraging, zero filler |
| **Motion & haptics** | none, or decorative-only | some springs, untied to meaning | springs + `numericText` transitions + `sensoryFeedback` on semantic events; each explainable |
| **Accessibility** | fixed font sizes, unlabeled charts, color-only state | partial (some labels) | semantic fonts, combined stat clusters, chart takeaway labels, state = color+text/symbol |

**Automatic caps** (apply after scoring):
- Any banned-list item present (purple-blue decorative gradient, rainbow stat cards,
  emoji icons, `.shadow(radius:n)` garnish, greeting header, rainbow pie, material on
  flat color, twin loud buttons): **cap total at 7.**
- Code does not compile: **score 0.** (Verify: `xcrun -sdk iphonesimulator swiftc -typecheck -target arm64-apple-ios17.0-simulator file.swift`)

**Interpretation:** 12–14 = ADA-grade · 9–11 = competent but generic · ≤8 = slop.

## Reference scores (these sources)

| Screen | Before | After |
|---|---|---|
| Drift home | 2 (greeting, rainbow stats, emoji, gradient card → capped) | 14 |
| Drift night detail | 3 (capped) | 14 |
| Ember recipe | 2 (capped) | 14 |
| Ember cooking | 4 (equal-weight steps, twin buttons → capped) | 14 |
| Ledger overview | 2 (capped) | 14 |
| Ledger category | 3 (capped) | 13 (motion minimal) |
| Jetline board | 3 (capped) | 14 |
| Jetline detail | 3 (capped) | 13 (motion minimal) |
| Tide today | 2 (capped) | 14 |
| Tide check-in | 4 (capped) | 14 |

## How to run the visual comparison

```bash
bash run.sh
```

Builds all 20 variants (10 apps × before/after), boots an iPhone simulator headless,
captures 30 real screenshots into `./screenshots/`, composites labeled before/after
collages into `./collages/` (native CoreGraphics tool, no mockups), and writes a
`README.md` with the hero collage and every pair. Existing screenshots are skipped —
delete a PNG to force recapture.
