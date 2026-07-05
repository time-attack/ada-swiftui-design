---
# ADA-Grade SwiftUI Design

Design doctrine for generating SwiftUI interfaces at Apple Design Award level.
Distilled from visual analysis of ADA winners/finalists 2022–2025 (Flighty, Lumy, Copilot,
Mela, Crouton, Gentler Streak, Watch Duty, Halide, Headspace, Not Boring Habits, Endel,
How We Feel, Bears Gratitude, CapWords, Rytmos, Art of Fauna, Vocabulary, Opal, Duolingo)
plus Apple's official judging language across all six award categories.
This is a process, not a theme. Never copy the examples literally — derive.

## Step 0 — Answer four questions before writing any code

Write the answers as a comment at the top of the file. If you cannot answer them,
you are not ready to design the screen.

1. **THE QUESTION** — What single question does this screen answer for the user?
   ("Is my flight on time?" / "Can I still spend?" / "What do I do right now?")
   The answer becomes the hero element. Everything else is supporting cast.
2. **THE METAPHOR** — What real-world design language does this domain already own?
   Airports own split-flap boards and signage. Cameras own dials and hardware.
   Cookbooks own editorial serif. Field guides own engravings and paper. Finance
   owns instrument clusters. Weather owns the sky itself. Borrow a system refined
   for decades; do not invent a generic "app look."
3. **THE TEMPERATURE** — Clinical, warm, urgent, playful, or calm?
   Decides canvas, type design, motion character, and voice. One temperature per
   app. Mixed temperature is the #1 tell of generated UI.
4. **THE STAGE** — Does this domain have a *place* the user cares about?
   A flight is somewhere over an ocean. Weather is a sky. A run is a route. A song
   is a room. Sleep is a night. If yes, the screen's architecture is **a world with
   surfaces floating on it** — not a stack of sections (see Rule 10). If the domain
   genuinely has no place (calculator, to-do list), it earns a flat page or an
   instrument instead. Skipping this question is how you end up bolting a map into
   the middle of a form.

## The Eleven Rules

1. **One hero per screen.** Give one element poster-scale dominance (3–6× secondary
   text, not 1.5×). A screen with four equal cards has no hero and no opinion.
2. **Color is information, never decoration.** Every hue encodes exactly one of:
   identity (a category owns one fixed hue everywhere — Copilot, NYT Games),
   state (on-time green / delayed amber / over-budget orange; How We Feel maps hue
   to emotional coordinates), or environment (time of day, temperature, season).
   Canvas = tinted neutral (near-white paper OR near-black instrument panel, e.g.
   `Color(red:0.05,green:0.05,blue:0.07)`, never pure #FFF/#000). ONE brand accent
   max on top of semantic hues.
3. **The background can be state.** Lumy's background is the actual sky gradient for
   the sun position; Headspace goes deep indigo for sleep. Ask: can the environment
   reflect the app's core state? If yes, that beats any card layout.
4. **Typography does the layout's work.** 3+ levels differing in BOTH size and
   weight. Micro-labels: uppercase/small-caps `.caption`, `.kerning(1.0–1.5)`,
   `.secondary`/`.tertiary`, above/below values (Watch Duty "ACRES/CONTAINMENT").
   Weight-mixed sentences via Text concatenation: bold the meaningful word only
   (Headspace "Stress **less**"). Type design follows metaphor: `.serif` editorial,
   `.rounded` friendly data, `.monospaced` technical. `.monospacedDigit()` on ALL
   changing numbers — non-negotiable.
5. **Numerals are heroes; units are servants.** Value huge (48–96pt bold, usually
   rounded); unit/cents/AM-PM demoted to ~40% size in `.secondary` via concatenation.
6. **Dim what isn't now.** Mela's cooking mode: current step full contrast, past and
   future steps visible but `.tertiary`/`.quaternary`. Apply to steps, timelines,
   calendars. Never hide context; recede it.
7. **Controls feel physical or stay stock — nothing in between.** Either pure system
   controls, or genuinely physical custom ones built from Capsule/Circle/Canvas with
   real geometry (Halide dials, Lumy tick scrubber, Opal gauge). Never half-restyle
   a system control.
8. **Motion is physics with meaning.** Springs only (`.spring(duration:0.4)` ballpark);
   `contentTransition(.numericText())` on changing numerals; haptics tied to semantic
   events not taps (`.sensoryFeedback(.success, trigger:)` on completion, `.warning`
   on overspend). Every animation must be explainable. Respect Reduce Motion.
9. **Write like a human on the user's side.** Headers are sentences with data folded
   in: "Sunset in 9 hours, 27 minutes" not "Next sunset: 19:42". Encourage, never
   judge (Gentler Streak): "Asleep by 11:04 — earlier than usual. Nice." No greetings,
   no filler, no emoji in UI copy.
10. **Draw the scene — and THE SCENE IS THE SCREEN, not a widget on the screen.**
    A screen of well-set type on a nice gradient is a **well-dressed spreadsheet**.
    Every hero screen gets a custom-drawn, domain-unique centerpiece that could not
    be copy-pasted into another app, and it must **encode real state** (clouds match
    the forecast, plane at actual progress, face matches the mood) or it's decoration:
    - **A scene**: the weather app draws the sky it reports; the sleep app hangs a
      crescent moon in a star field. Don't just tint the background — PUT THE
      SUBJECT IN IT.
    - **An instrument**: chronograph tick ring, camera dial, gauge, turntable, a
      globe with the route arcing across it.
    - **A character**: expressive drawn faces/mascots for emotional domains
      (Headspace, Duolingo, Bears Gratitude). No *unicode emoji glyphs* as icons —
      but custom-DRAWN faces are a signature winner move.

    **Architecture — choose BEFORE composing, from Step 0's STAGE answer:**
    - **A. Immersive world + floating surfaces** (domains with a place): the scene
      fills the ENTIRE screen edge-to-edge as the bottom Z-layer
      (`.ignoresSafeArea()`); ALL content floats above it on its own surfaces — a
      bottom sheet with a grabber, HUD chips in corners, a status strip. The user
      is IN the world; the data is the cockpit glass in front of it. (Flighty,
      Watch Duty, Slopes, every great map app.)
    - **B. Scroll narrative**: full-bleed scene header bleeding behind the status
      bar; content scrolls up and OVER it on an elevated rounded-top surface.
      For detail pages (recipe, album, workout summary).
    - **C. Flat page / instrument**: no scene. ONLY legitimate when the domain has
      no place (calculator, settings, lists).

    **The aquarium anti-pattern — instant fail**: a scene given a fixed
    `.frame(height:)` inside a VStack with text above and below. That's a fish tank
    on a shelf, not a world. If you write `SceneView().frame(height: 330)` between
    two text blocks, stop and re-architect to A or B. Commit emotionally: the
    scene's lighting sets the whole screen's palette, its accent spills onto the
    surfaces above (glow on the sheet edge, tinted hairlines), and labels live IN
    the world (pinned to map points, not in a legend below).

    **Surface grammar** — how content sits on a world:
    - Anything readable over a scene needs a real surface: rounded top corners
      (24–28pt), elevated fill (lighter tinted solid on dark; material only over
      imagery), hairline border, grabber if sheet-like.
    - Group ALL dense data into the surface — never scatter naked stat text over
      scenery. Inside: micro-label grid, one styled instrument, one CTA.
    - Inverse on flat canvases: don't wrap everything in cards.
    - Instruments deserve jewelry: a progress bar is a track + gradient fill +
      glowing position marker + labeled endpoints tied to real data — never a bare
      `ProgressView`.
    - **Lists of journeys are lists of instruments**: when rows represent processes
      in motion (flights, downloads, deliveries, workouts), every row carries its
      own mini instrument showing that item's REAL state — a tiny route line with
      the plane at its actual position, a ring at its actual fill. Rows differing
      only in text are a spreadsheet; rows at visibly different points in their
      journey are alive. Give each row one phase-appropriate fact line ("boards
      8:55" before, "lands 3:28" during, "bags at carousel 4" after).
    - Screens must end where the screen ends: pin the CTA to the bottom edge and
      let content breathe into the space between — a dead lower half reads as
      unfinished.

    **Scene integrity** — obey the scene's physics or change the shot:
    - Points sit ON the sphere/map/timeline; routes follow the surface; one light
      source; level horizons.
    - If the full object fights the layout (a whole globe rarely fits a phone
      honestly), CHANGE THE VIEWPOINT: zoom into the region, crop the sphere so
      only the route's arc is on screen, drop the horizon low. A cropped, committed
      shot beats a complete-but-fake diagram. Think like a cinematographer: every
      scene is a camera angle, not clip-art centered in a box.

    **How to build with zero assets:**
    - **Procedural `Canvas`**: clouds = 4–6 overlapping soft ellipses per puff;
      star fields = seeded-LCG random dots varying radius/opacity (never
      `Double.random` — seed it for stable renders); rain = angled capsule streaks;
      grooves = concentric circles; terrain = layered sine ridges.
    - **Pseudo-3D from 2D**: sphere = radial gradient offset toward the light +
      ellipse graticule (meridians = full-height ellipses of shrinking width;
      latitudes = squashed ellipses offset vertically) + rim glow; depth = 2–3
      parallax layers, near elements larger/softer.
    - **Glow/atmosphere**: `.shadow(color: accent.opacity(0.6), radius: 12)` on
      strokes, radial gradients fading to clear, `.blur` on a duplicate shape.
    - **Journey arcs**: `Path.addQuadCurve` dashed base + `.trim(to: progress)`
      solid overlay + subject at the bézier point `P = (1-t)²A + 2(1-t)tC + t²B`,
      rotated to `atan2` of the tangent.
    - **Faces**: two eyes + one mouth path in `Canvas`; expression = geometry
      (zigzag mouth = jittery, filled semicircle = excited, closed ∪-arcs = calm,
      flat heavy-lidded lines = drained).

    Info-density corollary — **rich, not busy**: three zones per screen (hero
    answer, living world, supporting surface). A sparse screen is as lazy as a
    cluttered one.
11. **Accessibility is structural.** Universal in Apple's judging across ALL categories:
    semantic font styles so Dynamic Type works (mentally test XXL); combine stat
    clusters with `.accessibilityElement(children:.combine)`; explicit
    `.accessibilityLabel` on charts AND scenes stating the takeaway; decorative scene
    layers get `.accessibilityHidden(true)` + `.allowsHitTesting(false)`; contrast
    ≥4.5:1; state never color-only (pair with symbol/text); custom gestures get
    VoiceOver equivalents.

## Banned list — instant fail

- Purple→blue (or any two-hue diagonal) gradient used decoratively
- `.shadow(radius:n)` garnish on flat colored cards
- 3–4 stat cards in different saturated colors with equal weight
- Unicode emoji as icons — use SF Symbols or custom-drawn glyphs
- "Welcome back, [Name]! 👋" or any greeting header
- Rainbow pie/donut charts with >4 slices
- `.ultraThinMaterial` on flat color (material blurs IMAGERY only)
- Same corner radius everywhere (radii are a scale: 8 / 12 / 16 / capsule)
- Two loud full-width buttons (one primary pill; secondary = text-quiet `.plain`)
- Centered-everything (left-align with strong baselines; center only heroes/empty states)
- Default `List` chrome for the app's soul content (lists are for settings)
- Typography-only screens with no drawn centerpiece (the well-dressed spreadsheet)
- The aquarium: a scene boxed in a `.frame(height:)` sandwich between text blocks
- Naked stat text scattered over scenery instead of grouped on a surface
- Bare `ProgressView`/`Slider` where the domain deserves a styled instrument

## Recipes (adapt values, never copy blindly)

World + sheet architecture (the immersive skeleton):
```swift
ZStack(alignment: .bottom) {
    WorldScene()                       // full-bleed, bottom Z-layer
        .ignoresSafeArea()
    VStack { HStack { hudChip(...); Spacer(); hudChip(...) }; Spacer() }  // HUD
    VStack(alignment: .leading) {      // the sheet: ALL dense data lives here
        Capsule().fill(.white.opacity(0.25)).frame(width: 36, height: 5)
            .frame(maxWidth: .infinity)
        // hero answer, styled instrument, fact grid, one CTA
    }
    .padding(22)
    .background(
        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
            .fill(elevatedFill)
            .overlay(UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .stroke(.white.opacity(0.08), lineWidth: 1))
            .shadow(color: .black.opacity(0.5), radius: 24, y: -10)
            .ignoresSafeArea(edges: .bottom))
}
```

Seeded procedural drawing (stable across renders — the scene primitive):
```swift
Canvas { ctx, size in
    var state: UInt64 = 7   // seed
    func rnd() -> CGFloat {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return CGFloat((state >> 33) % 1000) / 1000
    }
    // stars / raindrops / particles / cloud puffs from rnd()...
}
.allowsHitTesting(false)
.accessibilityHidden(true)
```

Jeweled progress instrument (never a bare ProgressView):
```swift
GeometryReader { geo in
    let x = geo.size.width * progress
    ZStack(alignment: .leading) {
        Capsule().fill(.white.opacity(0.10)).frame(height: 5)          // track
        Capsule().fill(LinearGradient(colors: [hue.opacity(0.25), hue],
                                      startPoint: .leading, endPoint: .trailing))
            .frame(width: x, height: 5)
            .shadow(color: hue.opacity(0.8), radius: 5)                // lit trail
        Image(systemName: subjectSymbol)                               // the subject
            .shadow(color: hue.opacity(0.9), radius: 5)
            .offset(x: x - 7)
    }
}
.frame(height: 20)
// + labeled endpoints (codes, times) above; takeaway caption below
```

Pseudo-3D globe, cropped like a camera shot (radius LARGER than the screen):
```swift
let r = screenWidth * 0.78            // cropped = cinematic, honest
ZStack {
    Circle().fill(RadialGradient(colors: [litColor, darkColor],
        center: UnitPoint(x: 0.38, y: 0.28), startRadius: r*0.1, endRadius: r*1.15))
    ForEach([1.0, 0.74, 0.48, 0.20], id: \.self) { f in    // meridians
        Ellipse().stroke(.white.opacity(0.08), lineWidth: 1)
            .frame(width: 2*r*f, height: 2*r)
    }
    ForEach([-0.5, -0.25, 0.0, 0.25, 0.5], id: \.self) { lat in  // latitudes
        let w = 2*r*sqrt(max(0.001, 1 - lat*lat))
        Ellipse().stroke(.white.opacity(0.08), lineWidth: 1)
            .frame(width: w, height: w*0.20).offset(y: r*lat)
    }
}
.frame(width: 2*r, height: 2*r).position(globeCenter)
// endpoints must be INSIDE the disc: point = center + (dx*r, dy*r), dx²+dy² < 1
```

Journey arc with subject at real progress:
```swift
Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
    .stroke(.white.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [3,5]))
Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
    .trim(from: 0, to: t)
    .stroke(accent, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
    .shadow(color: accent.opacity(0.9), radius: 5)
Image(systemName: "airplane")
    .rotationEffect(.radians(Double(atan2(dy, dx))))   // tangent of the bézier
    .position(x: bezX(t), y: bezY(t))
```

Micro-label + hero value:
```swift
VStack(alignment: .leading, spacing: 2) {
    Text("Left to spend")
        .font(.subheadline.smallCaps().weight(.medium))
        .kerning(1.2).foregroundStyle(.secondary)
    (Text("$2,847").font(.system(size: 64, weight: .bold, design: .rounded))
     + Text(".60").font(.system(size: 32, weight: .semibold, design: .rounded))
        .foregroundStyle(.secondary))
        .monospacedDigit()
        .contentTransition(.numericText())
}
.accessibilityElement(children: .combine)
```

Semantic state, one source of truth (state always paired with text, never color alone):
```swift
enum FlightState { case onTime, delayed, boarding
    var hue: Color { switch self {
        case .onTime:  Color(red: 0.30, green: 0.85, blue: 0.55)
        case .delayed: Color(red: 1.00, green: 0.72, blue: 0.25)
        case .boarding: Color(red: 0.40, green: 0.70, blue: 1.00) } }
}
```

Contextual dimming (the "now" spotlight):
```swift
ForEach(steps.indices, id: \.self) { i in
    StepView(steps[i])
        .foregroundStyle(i == current ? AnyShapeStyle(.primary)
                        : AnyShapeStyle(i < current ? .quaternary : .tertiary))
}
```

Identity-hue row (category color used narrowly: icon chip + bar fill only):
```swift
Image(systemName: cat.symbol)
    .font(.subheadline.weight(.semibold))
    .foregroundStyle(cat.hue)
    .frame(width: 30, height: 30)
    .background(cat.hue.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
// + name, right-aligned tabular numbers, thin capsule progress in cat.hue
```

One primary action (text in canvas color, not default white-on-blue):
```swift
Button { } label: {
    Label("Wind down", systemImage: "moon.stars.fill")
        .font(.body.weight(.semibold))
        .frame(maxWidth: .infinity).padding(.vertical, 15)
}
.background(accent, in: Capsule())
.foregroundStyle(canvasColor)
```

Data-driven micro-chart (form follows data; bar height = value; best/current highlighted):
```swift
HStack(alignment: .bottom, spacing: 10) {
    ForEach(days) { d in
        VStack(spacing: 6) {
            Capsule().fill(d.isBest ? AnyShapeStyle(accent) : AnyShapeStyle(.quaternary))
                .frame(width: 26, height: d.value * scale)
            Text(d.label).font(.caption2).foregroundStyle(.tertiary)
        }
    }
}
.accessibilityElement(children: .ignore)
.accessibilityLabel("…one-sentence takeaway…")
```

## Genre playbooks

| Genre | Architecture | Canvas | Type | Centerpiece ideas |
|---|---|---|---|---|
| Data/utility (flights, finance, weather) | A: world + sheet (if it has a place) else instrument panel | near-black | rounded/mono numerals, small-caps labels | cropped globe + route arc, drawn sky with live weather, gauge cluster |
| Wellness/health | A or B: environmental world | gradient sky or warm paper | rounded, generous | moon + stars, breathing rings, drawn characters/faces |
| Editorial/content (recipes, reading) | B: scroll narrative | paper white/cream | serif display + sans chrome | full-bleed imagery header, engraving-style illustration, drop caps |
| Creative tool (camera, drawing, music) | A: content IS the world, HUD chrome | true dark | condensed/mono technical | turntable with grooves, lens dial, waveform |
| Playful/learning (kids, games, language) | A or C | flat saturated field, one hue per world | chunky, custom-feeling | mascot faces, sticker cutouts, isometric mini-worlds |

## Pre-flight checklist — score before returning code

Rate honestly, 0–2 each. **Under 16/18: revise before answering.**
1. Hero: can a stranger say what the screen is about in 2 seconds?
2. Centerpiece: custom-drawn, domain-unique, encodes real state? Could this screen
   be mistaken for a styled spreadsheet? (If yes → 0.)
3. Architecture: if the domain has a place, is the world full-bleed with content on
   real floating surfaces? Scene boxed in a `.frame(height:)` sandwich → 0. Naked
   stats over scenery → 0. Scene geometry honest, or viewpoint changed to keep it
   honest?
4. Color: does every non-neutral hue encode identity, state, or environment?
5. Type: 3+ levels (size AND weight)? numerals monospaced? labels kerned small-caps?
6. Metaphor: is a nameable domain design language visible?
7. Voice: human sentences? zero greetings/filler/emoji?
8. Motion/haptics: springs + numericText + semantic feedback, each explainable?
9. Slop scan: zero banned-list items? Rich-not-busy: three zones present?

Then a11y gate (must pass): Dynamic Type survives XXL · stat clusters combined ·
charts AND scenes labeled · decorative layers hidden from VoiceOver · state never
color-only.
