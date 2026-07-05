# Claude Code Prompt — SwiftUI Design Skill Benchmark

Paste everything below the line into Claude Code, run from the root of this repo
on a Mac with Xcode + an iOS Simulator runtime installed.

---

You are running a rigorous, parallel benchmark of SwiftUI design-guidance skills.
The repo you are in contains `SKILL.md` (the "ADA" skill under test) and
`evals/EVALS.md` (the scoring rubric). Work through the phases below. Use
parallel subagents (Task tool) wherever phases allow it. Never let one variant's
output leak into another variant's context.

## Phase 1 — Research 3 competitor skills

Find the 3 most credible competing "SwiftUI / iOS UI design guidance" prompt
artifacts that people actually use with coding agents. Look for:
- popular Cursor rules files for SwiftUI/iOS design (cursor.directory, GitHub)
- Claude/agent skill files or system prompts for iOS UI design (awesome-claude-code
  lists, gists, repos)
- widely shared "design like Apple" prompt guides

Selection criteria: actually about UI/visual design in SwiftUI (not just Swift
style/architecture), non-trivial length (> 40 lines of real guidance), and some
evidence of adoption (stars, forks, directory ranking). For each competitor:
- save the exact text verbatim to `benchmark/competitors/<slug>/SKILL.md`
- record source URL, author, adoption evidence, and retrieval date in
  `benchmark/competitors/<slug>/SOURCE.md`

If a competitor is longer than ~1,500 lines, keep it whole anyway — do not edit
or "improve" any competitor text. They compete as-is.

## Phase 2 — Generate 10 × 5 apps in parallel, uncontaminated

The 10 briefs (use VERBATIM as the entire design request, one screen each):

1.  "Build a SwiftUI screen for a water-intake tracker."
2.  "Build a SwiftUI screen for a parking meter timer."
3.  "Build a SwiftUI screen showing today's stock portfolio."
4.  "Build a SwiftUI screen for a podcast player."
5.  "Build a SwiftUI screen for a workout rest timer."
6.  "Build a SwiftUI screen showing my monthly subscriptions."
7.  "Build a SwiftUI screen for tonight's moon phase."
8.  "Build a SwiftUI screen for a pomodoro focus session."
9.  "Build a SwiftUI screen for tracking a road trip in progress."
10. "Build a SwiftUI screen for a baby sleep log."

The 5 variants per brief:
- `baseline` — the brief only. NO design guidance of any kind.
- `comp-<slug1>`, `comp-<slug2>`, `comp-<slug3>` — brief + that competitor's full text.
- `ada` — brief + this repo's `SKILL.md` full text.

That is 50 generations. Rules — these are the integrity of the benchmark:
- One subagent per generation, launched in parallel batches. Each subagent's
  context contains ONLY: the brief, (for non-baseline) the single skill text, and
  the output-format instructions below. It must NOT see this repo's examples,
  other variants, other skills, or the rubric.
- Output format for every generation: ONE self-contained file at
  `benchmark/generated/<brief-slug>/<variant>.swift` containing a complete
  `@main` SwiftUI App with realistic sample data, compilable STANDALONE with:
  `xcrun -sdk iphonesimulator swiftc -typecheck -parse-as-library -target arm64-apple-ios17.0-simulator <file>`
- After generation, compile-gate every file with exactly that command. If a file
  fails, give the SAME subagent (same context) up to 2 repair attempts with the
  compiler errors. Record final compile status; a file that still fails scores 0
  and is excluded from rendering.

## Phase 3 — Render all 50 on the simulator

Adapt `examples/before-after/run.sh` (this repo) into `benchmark/render.sh`:
boot an iPhone simulator headless, and for each compiled file build a minimal
.app bundle (`-parse-as-library`, Info.plist with `UILaunchScreen`), install,
launch, wait 2.5 s, screenshot to
`benchmark/screenshots/<brief-slug>-<variant>.png`, terminate. Set the status
bar to 9:41 first. Reuse one booted device for everything.

## Phase 4 — Blind scoring

Score every rendered screenshot + its source with `evals/EVALS.md` (7 dimensions
0–2, automatic caps, compile-fail = 0). To reduce bias:
- Randomize scoring order and strip variant names: present each item to a fresh
  scoring subagent as "Screen #N" with only the screenshot path + source path +
  the rubric. Collect scores, then re-attach identities afterward.
- The scorer must quote the specific evidence for every dimension score
  (one line each) — no bare numbers.

## Phase 5 — COMPARISON.md

Write `benchmark/COMPARISON.md`:
1. Method summary (competitors chosen + why, generation rules, blinding).
2. Master table: 10 briefs × 5 variants, total score per cell, mean per variant,
   compile-pass rate per variant.
3. Per-brief sections: the 5 screenshots side by side (markdown image row,
   baseline first, then competitors alphabetical, ada last), each with its
   score breakdown and the scorer's one-line evidence quotes.
4. Findings: where each skill systematically wins/loses (color discipline,
   scene-making, architecture, typography, a11y), the banned-list violations per
   variant, and 3 concrete weaknesses found in the ADA skill with suggested
   patches.
5. Threats to validity (single-model generation, single scorer, static shots).

Commit everything to a branch `benchmark-run-<date>` and print the final mean
scores table to the console.

Constraints: never fabricate a competitor, a compile result, or a score. If a
phase-1 search finds fewer than 3 real competitors, say so and proceed with what
exists. Screenshots must be real simulator captures.
