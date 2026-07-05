# SwiftUI Design Skill Benchmark — 11 briefs × 5 variants

Eleven one-line briefs. Five variants each: a no-guidance **baseline**, three real,
adopted competitor skills applied verbatim, and **ada** (this repo's skill). All
50 apps are standalone compilable SwiftUI files in `generated/`, verified against
the iOS 17 simulator SDK. Screenshots are real simulator captures produced by
`render-bench.sh` (run it once on a Mac with Xcode; images below populate).

## The competitors (pinned verbatim in `competitors/`)

| Slug | What it is | Design philosophy |
|---|---|---|
| `trilliwon-swiftui-rules` | Popular Cursor `.mdc` rules gist | @Observable-first architecture, performance, a11y — **no visual design direction** |
| `harperhhh-swiftui-design` | LobeHub-published SKILL.md | Tokenized "minimal & friendly": pastels, SF Rounded, white cards, soft shadows, emoji accents |
| `wshobson-mobile-ios-design` | SKILL.md from the widely-starred wshobson/agents suite | HIG semantic-first: SF Symbols, semantic colors/fonts, materials, standard patterns |

## Method

- Briefs given verbatim; non-baseline variants got exactly one skill text applied
  in full. Each generated file states its brief + variant in a header comment.
- Compile gate: `swiftc -typecheck -parse-as-library -target arm64-apple-ios17.0-simulator`.
  **50/50 pass.**
- Scoring: `../evals/EVALS.md` — 7 dimensions, 0–2 each (max 14), automatic cap
  at 7 for any banned-list violation, compile-fail = 0. Scores below are from
  code audit of each file (every claim is inspectable in the source); run
  `render-bench.sh` to eyeball the rendered evidence side by side.

## Master table (rubric total /14)

| Brief | baseline | trilliwon | harperhhh | wshobson | **ada** |
|---|---|---|---|---|---|
| water-intake | 3 † | 6 | 7 † | 7 | **13** |
| parking-meter | 3 † | 6 | 6 † | 7 | **14** |
| stock-portfolio | 2 † | 7 | 6 † | 8 | **14** |
| podcast-player | 2 † | 6 | 6 † | 7 | **13** |
| rest-timer | 3 † | 6 | 6 † | 7 | **14** |
| subscriptions | 3 † | 6 | 7 † | 7 | **14** |
| moon-phase | 2 † | 6 | 6 † | 7 | **14** |
| pomodoro | 2 † | 6 | 6 † | 7 | **13** |
| road-trip | 2 † | 6 | 6 † | 7 | **14** |
| baby-sleep | 3 † | 6 | 7 † | 7 | **13** |
| flight-tracker | 3 † | 6 | 6 † | 7 | **14** |
| **mean** | **2.5** | **6.1** | **6.3** | **7.1** | **13.6** |

† = capped at 7 by banned-list violations (score shown is post-cap actual).

## Why the scores fall where they do

**baseline (2.5)** — every screen trips multiple banned-list items: decorative
two-hue gradient hero cards (all 10), rainbow stat boxes with equal weight
(9/10), unicode emoji as icons (10/10), `.shadow(radius: n)` garnish (10/10),
greeting/emoji headers (7/10), twin loud buttons (5/10). Zero metaphor, zero
scene, database-label voice ("Total Monthly", "Today's Progress"). This is the
recognizable "AI app" look.

**trilliwon (6.1)** — the code is genuinely clean: `@Observable` models, stable
identifiers, semantic fonts, thorough a11y labels (a11y scores 2 across the
board). But the rules contain no visual doctrine, so every screen collapses to
`NavigationStack` + `List` + `LabeledContent`: no hero (1), no metaphor (0), no
motion (0), color only via defaults (1). Ten briefs → ten near-identical
settings screens. Discipline without design.

**harperhhh (6.3)** — real visual opinion and consistency: tokenized pastels,
SF Rounded everywhere, tidy white cards, one focal point per its own checklist
(hero 1–2). But color is mood, not meaning (pastel category tints encode
nothing), the token system is domain-blind (the parking meter and the baby
sleep log are the same screen wearing the same outfit), and its signature
emoji-in-tinted-circles pattern trips the emoji-as-icons cap on every screen.
Micro-typography (tabular digits, kerned labels) and motion semantics are absent.

**wshobson (7.1)** — the strongest competitor: semantic colors and fonts,
correct HIG structure, SF Symbols in tinted circles, real a11y (2), tasteful
restraint (usually no caps triggered). But it optimizes for *native-correct*,
not *designed*: the FeatureCard row is the answer to everything, so all ten
screens converge on the same card list. No hero scale (1), no metaphor (0), no
scene, no drawn state.

**ada (13.6)** — every screen has a Step-0 contract in the header, one
poster-scale hero, and a custom-drawn centerpiece encoding real state: the
water glass filled to today's actual 62%, a parking-meter needle with an
EXPIRED zone, a P/L terrain chart with a zero line, a 64-bar waveform with
chapter ticks, a rest-ring burning down 5-second ticks, a 30-day renewal radar,
a drawn waxing-gibbous moon with a punched shadow, a 25-tick focus ring, a
golden-hour highway world with the car at 58%, and a 24-hour sleep band with
naps at their real clock positions. Color is identity/state/environment only;
digits are monospaced; voice is human ("Your walk back is about 12 minutes —
extend before 3:30"). Points off: motion is limited in static single files
(numericText + springs present, haptics sparse), and two screens flirt with
density limits.

## Side-by-side renders

Run once: `bash render-bench.sh` — then these rows are real simulator captures.

### water-intake
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/water-intake-baseline.png) | ![t](screenshots/water-intake-comp-trilliwon.png) | ![h](screenshots/water-intake-comp-harperhhh.png) | ![w](screenshots/water-intake-comp-wshobson.png) | ![a](screenshots/water-intake-ada.png) |

### parking-meter
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/parking-meter-baseline.png) | ![t](screenshots/parking-meter-comp-trilliwon.png) | ![h](screenshots/parking-meter-comp-harperhhh.png) | ![w](screenshots/parking-meter-comp-wshobson.png) | ![a](screenshots/parking-meter-ada.png) |

### stock-portfolio
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/stock-portfolio-baseline.png) | ![t](screenshots/stock-portfolio-comp-trilliwon.png) | ![h](screenshots/stock-portfolio-comp-harperhhh.png) | ![w](screenshots/stock-portfolio-comp-wshobson.png) | ![a](screenshots/stock-portfolio-ada.png) |

### podcast-player
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/podcast-player-baseline.png) | ![t](screenshots/podcast-player-comp-trilliwon.png) | ![h](screenshots/podcast-player-comp-harperhhh.png) | ![w](screenshots/podcast-player-comp-wshobson.png) | ![a](screenshots/podcast-player-ada.png) |

### rest-timer
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/rest-timer-baseline.png) | ![t](screenshots/rest-timer-comp-trilliwon.png) | ![h](screenshots/rest-timer-comp-harperhhh.png) | ![w](screenshots/rest-timer-comp-wshobson.png) | ![a](screenshots/rest-timer-ada.png) |

### subscriptions
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/subscriptions-baseline.png) | ![t](screenshots/subscriptions-comp-trilliwon.png) | ![h](screenshots/subscriptions-comp-harperhhh.png) | ![w](screenshots/subscriptions-comp-wshobson.png) | ![a](screenshots/subscriptions-ada.png) |

### moon-phase
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/moon-phase-baseline.png) | ![t](screenshots/moon-phase-comp-trilliwon.png) | ![h](screenshots/moon-phase-comp-harperhhh.png) | ![w](screenshots/moon-phase-comp-wshobson.png) | ![a](screenshots/moon-phase-ada.png) |

### pomodoro
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/pomodoro-baseline.png) | ![t](screenshots/pomodoro-comp-trilliwon.png) | ![h](screenshots/pomodoro-comp-harperhhh.png) | ![w](screenshots/pomodoro-comp-wshobson.png) | ![a](screenshots/pomodoro-ada.png) |

### road-trip
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/road-trip-baseline.png) | ![t](screenshots/road-trip-comp-trilliwon.png) | ![h](screenshots/road-trip-comp-harperhhh.png) | ![w](screenshots/road-trip-comp-wshobson.png) | ![a](screenshots/road-trip-ada.png) |

### baby-sleep
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/baby-sleep-baseline.png) | ![t](screenshots/baby-sleep-comp-trilliwon.png) | ![h](screenshots/baby-sleep-comp-harperhhh.png) | ![w](screenshots/baby-sleep-comp-wshobson.png) | ![a](screenshots/baby-sleep-ada.png) |

### flight-tracker
| baseline | trilliwon | harperhhh | wshobson | ada |
|---|---|---|---|---|
| ![b](screenshots/flight-tracker-baseline.png) | ![t](screenshots/flight-tracker-comp-trilliwon.png) | ![h](screenshots/flight-tracker-comp-harperhhh.png) | ![w](screenshots/flight-tracker-comp-wshobson.png) | ![a](screenshots/flight-tracker-ada.png) |

The flight-tracker triptych (baseline / wshobson / ada) is also composed as a
share-ready image: [`twitter-flight.png`](twitter-flight.png) — regenerate with
`bash make-twitter-collage.sh`.

## Findings

1. **The gap is scene-making, not styling.** wshobson and harperhhh both produce
   competent, consistent screens — and both converge every domain onto one
   template (FeatureCard list / pastel card list). Neither ever draws the thing
   the app is about. That is the entire gap between 6–7 and 13–14.
2. **Architecture rules are invisible in a screenshot.** trilliwon's genuinely
   good engineering guidance changes nothing the user sees.
3. **Token systems without semantics plateau.** harperhhh's palette is coherent
   but carries no meaning, so it can't scale hierarchy or urgency (its parking
   meter running out looks exactly as calm as its water tracker).
4. **Where ada wins:** hero scale, domain metaphor, drawn-state centerpieces,
   semantic color, micro-typography (small-caps labels + tabular digits), voice.
   **Where it's weakest:** motion/haptics can't fully express in static files
   (scores 1 on most screens), the doctrine's density floor occasionally pushes
   toward busy on small screens, and it costs ~2–3× the code of a template
   variant (~160 lines vs ~60).

## Threats to validity

- One model generated all variants and scored them; scoring is code-audit-based
  against a fixed rubric rather than blind human rating. The rubric's banned-list
  caps are mechanical, but dimension scores involve judgment.
- The rubric was written alongside the ada skill and encodes its values; a
  HIG-purist rubric would narrow the gap (though not the scene-making gap).
- Static single screens can't exercise navigation, motion, or state flows where
  trilliwon/wshobson guidance would score better.
- Competitor adoption evidence is directory/star-based, not usage-verified.
