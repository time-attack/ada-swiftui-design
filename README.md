# ADA-Grade SwiftUI Design Skill

A design-doctrine skill that makes coding agents (Claude, Claude Code, Cursor)
produce SwiftUI interfaces that look designed, not generated — distilled from
visual analysis of **Apple Design Award winners and finalists 2022–2025** and
Apple's official judging language across all six award categories.

![hero](renders/collages/hero.png)

*Every image in this repo is a real iOS Simulator render. No mockups.*

## What's in the skill

Not a theme — a process. The short version:

- **Step 0** — four questions before any code: the screen's single QUESTION, the
  domain's METAPHOR, the emotional TEMPERATURE, and the STAGE (does this domain
  have a *place*?).
- **The Eleven Rules** — one hero per screen; color as information only;
  background-as-state; typography doing the layout's work; numerals as heroes;
  contextual dimming; physical-or-stock controls; motion as physics; human
  voice; **draw the scene (and the scene is the screen, not a widget on it)**;
  structural accessibility.
- **Architecture doctrine** — immersive world + floating surfaces / scroll
  narrative / flat page, with named anti-patterns (the aquarium, the
  well-dressed spreadsheet, naked stats over scenery).
- **Zero-asset scene recipes** — seeded procedural Canvas drawing (clouds, star
  fields, terrain), pseudo-3D globes from gradients + graticules, journey arcs
  with subjects at real progress, faces-as-geometry.
- **A self-scoring pre-flight checklist** the agent must pass before answering.

The full skill: [`SKILL.md`](SKILL.md)

## Before / after

Same prompts, same model. The only difference is the skill.

![jetline](renders/collages/pair-jetline-flight.png)
![aero](renders/collages/pair-aero-forecast.png)
![tide](renders/collages/pair-tide-checkin.png)
![drift](renders/collages/pair-drift-home.png)

All 15 pairs: [`renders/collages/`](renders/collages/) · sources:
[`examples/before-after/`](examples/before-after/)

## Gallery — 8 domains, one doctrine

| | | | |
|---|---|---|---|
| ![run](renders/gallery/gallery-1-run.png) | ![surf](renders/gallery/gallery-2-surf.png) | ![coffee](renders/gallery/gallery-3-coffee.png) | ![breathe](renders/gallery/gallery-4-breathe.png) |
| ![delivery](renders/gallery/gallery-5-delivery.png) | ![sky](renders/gallery/gallery-6-skytonight.png) | ![ev](renders/gallery/gallery-7-evcharge.png) | ![plant](renders/gallery/gallery-8-plant.png) |

Sources: [`examples/gallery/`](examples/gallery/)

## Use it

**Claude Code / Claude:** paste `SKILL.md` into your project as a skill or
include it in context when asking for SwiftUI UI.

**Cursor:** drop the body of `SKILL.md` into `.cursor/rules/swiftui-design.mdc`.

## Reproduce the renders

Requires Xcode + an iOS Simulator runtime (macOS).

```bash
# 15 before/after pairs + collages
bash examples/before-after/run.sh

# 8-domain gallery
bash examples/gallery/run-gallery.sh
```

Both scripts compile the sources with `swiftc` against the iphonesimulator SDK,
boot a simulator headless, capture real screenshots, and composite collages with
a dependency-free CoreGraphics tool.

## Benchmark it against other skills

[`claude-code/BENCHMARK_PROMPT.md`](claude-code/BENCHMARK_PROMPT.md) is a
ready-to-paste Claude Code prompt that:

1. researches 3 real competitor SwiftUI design skills/rules and pins them verbatim,
2. generates **10 basic apps × 5 variants** (no-guidance baseline, 3 competitors,
   this skill) with 50 parallel, contamination-free subagents,
3. compile-gates and renders all 50 on the simulator,
4. blind-scores everything with [`evals/EVALS.md`](evals/EVALS.md),
5. writes `benchmark/COMPARISON.md` with side-by-side screenshots, score tables,
   and an honest weaknesses section for this skill.

## Evals

[`evals/EVALS.md`](evals/EVALS.md) — 7 scored dimensions (hero clarity, color
discipline, typography, metaphor, voice, motion/haptics, accessibility) with
automatic caps for banned-list violations and a compile gate. Reference scores
included for every example in this repo.

## Research basis

Winner lists, category justifications, and press analysis for ADA 2022–2025 were
collected from Apple's newsroom/developer pages and coverage (MacStories,
TechCrunch, 9to5Mac), then ~20 winning apps' App Store screenshots were visually
analyzed for recurring craft patterns (Lumy's sky-as-data, Mela's cooking-mode
dimming, Copilot's instrument-panel numerals, Flighty's airport signage, How We
Feel's color-as-emotion, Watch Duty's crisis hierarchy, and more). The doctrine
generalizes those patterns; it never copies an app.

## License

MIT
