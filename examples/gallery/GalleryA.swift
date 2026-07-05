// SKILL GALLERY — 8 screens, 8 domains, one doctrine.
// Select screen with EVAL_SCREEN=1...8 (or --screen N).
// File A: entry + screens 1-4 (Run, Surf, Coffee, Breathe)
import SwiftUI

@main
struct GalleryApp: App {
    var body: some Scene { WindowGroup { GalleryRoot() } }
}

struct GalleryRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        var n = Int(env["EVAL_SCREEN"] ?? "") ?? 1
        if let i = args.firstIndex(of: "--screen"), args.indices.contains(i + 1),
           let v = Int(args[i + 1]) { n = v }
        return Group {
            switch n {
            case 1: RunScreen()
            case 2: SurfScreen()
            case 3: CoffeeScreen()
            case 4: BreatheScreen()
            case 5: DeliveryScreen()
            case 6: SkyTonightScreen()
            case 7: ChargeScreen()
            default: PlantScreen()
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Shared surface helpers
// ---------------------------------------------------------------------------

struct SheetSurface: ViewModifier {
    var fill: Color
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                    .fill(fill)
                    .overlay(
                        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1))
                    .shadow(color: .black.opacity(0.5), radius: 24, y: -10)
                    .ignoresSafeArea(edges: .bottom))
    }
}

struct Grabber: View {
    var body: some View {
        Capsule().fill(.white.opacity(0.25))
            .frame(width: 36, height: 5)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
    }
}

func hudChip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Color.black.opacity(0.35), in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
}

func microLabel(_ s: String, tint: AnyShapeStyle = AnyShapeStyle(HierarchicalShapeStyle.secondary)) -> some View {
    Text(s).font(.caption.smallCaps()).kerning(1.0).foregroundStyle(tint)
}

// ===========================================================================
// SCREEN 1 — RUN (Architecture A: dawn terrain world + pace sheet)
//   QUESTION: "am I on pace?"  METAPHOR: the trail at dawn.  TEMP: urgent-warm.
//   STAGE: a run IS a place — ridgelines the runner is moving through.
// ===========================================================================

struct RunScreen: View {
    private let accent = Color(red: 1.00, green: 0.55, blue: 0.30)
    private let progress: CGFloat = 0.64

    var body: some View {
        ZStack(alignment: .bottom) {
            // World: dawn sky over three parallax ridgelines, route on the near one
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    LinearGradient(stops: [
                        .init(color: Color(red: 0.09, green: 0.08, blue: 0.20), location: 0),
                        .init(color: Color(red: 0.30, green: 0.16, blue: 0.28), location: 0.45),
                        .init(color: Color(red: 0.95, green: 0.55, blue: 0.35), location: 0.78),
                    ], startPoint: .top, endPoint: .bottom)

                    // rising sun
                    Circle()
                        .fill(RadialGradient(colors: [Color(red: 1, green: 0.85, blue: 0.6),
                                                      .clear],
                                             center: .center, startRadius: 4, endRadius: 90))
                        .frame(width: 180, height: 180)
                        .position(x: w * 0.68, y: h * 0.52)

                    // three ridgelines, far to near
                    ridge(w: w, h: h, base: 0.60, amp: 26, phase: 1.2,
                          color: Color(red: 0.36, green: 0.22, blue: 0.34))
                    ridge(w: w, h: h, base: 0.68, amp: 34, phase: 3.8,
                          color: Color(red: 0.24, green: 0.15, blue: 0.26))
                    ridge(w: w, h: h, base: 0.76, amp: 44, phase: 6.1,
                          color: Color(red: 0.13, green: 0.09, blue: 0.17))

                    // the route hugs the near ridge; runner dot at real progress
                    routePath(w: w, h: h)
                        .stroke(.white.opacity(0.25),
                                style: StrokeStyle(lineWidth: 2, dash: [1, 6]))
                    routePath(w: w, h: h)
                        .trim(from: 0, to: progress)
                        .stroke(accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .shadow(color: accent.opacity(0.9), radius: 5)
                    Circle().fill(.white)
                        .frame(width: 11, height: 11)
                        .shadow(color: accent, radius: 7)
                        .position(routePoint(w: w, h: h, t: progress))
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            // HUD
            VStack {
                HStack {
                    hudChip { Text("MORNING RUN · 10K")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    hudChip {
                        HStack(spacing: 5) {
                            Image(systemName: "location.fill").font(.system(size: 9))
                            Text("GPS").font(.caption.weight(.semibold))
                        }.foregroundStyle(Color(red: 0.3, green: 0.85, blue: 0.55))
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            // Sheet
            VStack(alignment: .leading, spacing: 0) {
                Grabber()
                (Text("6.4").font(.system(size: 64, weight: .bold, design: .rounded))
                 + Text(" km").font(.system(size: 30, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary))
                    .monospacedDigit()
                    .padding(.top, 12)
                    .accessibilityLabel("6.4 kilometers")
                Text("11 seconds ahead of your best 10K. Keep this.")
                    .font(.callout).foregroundStyle(.secondary).padding(.top, 2)

                // distance instrument
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        let x = geo.size.width * progress
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.10)).frame(height: 5)
                            Capsule().fill(LinearGradient(colors: [accent.opacity(0.25), accent],
                                                          startPoint: .leading, endPoint: .trailing))
                                .frame(width: x, height: 5)
                                .shadow(color: accent.opacity(0.8), radius: 5)
                            Image(systemName: "figure.run")
                                .font(.system(size: 14, weight: .semibold))
                                .shadow(color: accent, radius: 5)
                                .offset(x: x - 7)
                        }.frame(maxHeight: .infinity, alignment: .center)
                    }.frame(height: 18)
                    HStack {
                        microLabel("Pace 4:52 /km")
                        Spacer()
                        microLabel("10K in 36:10", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                    }
                }
                .padding(.top, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("6.4 of 10 kilometers, pace 4 52 per kilometer")

                // splits: form follows data
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array([292, 288, 296, 285, 290, 287].enumerated()), id: \.offset) { i, s in
                        VStack(spacing: 4) {
                            Capsule()
                                .fill(i == 5 ? AnyShapeStyle(accent) : AnyShapeStyle(.white.opacity(0.18)))
                                .frame(height: CGFloat(320 - s) * 1.4)
                            Text("\(i + 1)").font(.caption2).foregroundStyle(.tertiary)
                        }.frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 66)
                .padding(.top, 18)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Kilometer splits, fastest 4:45 on kilometer 4")

                Button {} label: {
                    Label("Pause run", systemImage: "pause.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                }
                .background(accent, in: Capsule())
                .foregroundStyle(Color(red: 0.1, green: 0.05, blue: 0.05))
                .padding(.top, 20).padding(.bottom, 8)
            }
            .modifier(SheetSurface(fill: Color(red: 0.11, green: 0.09, blue: 0.14)))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func ridge(w: CGFloat, h: CGFloat, base: CGFloat, amp: CGFloat,
                       phase: CGFloat, color: Color) -> some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: h))
            p.addLine(to: CGPoint(x: 0, y: h * base))
            var x: CGFloat = 0
            while x <= w {
                let y = h * base + sin((x / w) * 4.4 + phase) * amp
                p.addLine(to: CGPoint(x: x, y: y))
                x += 8
            }
            p.addLine(to: CGPoint(x: w, y: h))
            p.closeSubpath()
        }.fill(color)
    }

    private func routePoint(w: CGFloat, h: CGFloat, t: CGFloat) -> CGPoint {
        let x = w * (0.06 + 0.88 * t)
        let y = h * 0.76 + sin((x / w) * 4.4 + 6.1) * 44 - 6
        return CGPoint(x: x, y: y)
    }
    private func routePath(w: CGFloat, h: CGFloat) -> Path {
        Path { p in
            p.move(to: routePoint(w: w, h: h, t: 0))
            var t: CGFloat = 0
            while t <= 1 { p.addLine(to: routePoint(w: w, h: h, t: t)); t += 0.02 }
        }
    }
}

// ===========================================================================
// SCREEN 2 — SURF (Architecture A: sea world + tide sheet)
//   QUESTION: "when should I paddle out?"  METAPHOR: standing on the beach.
//   TEMP: calm.  STAGE: the ocean, obviously.
// ===========================================================================

struct SurfScreen: View {
    private let seafoam = Color(red: 0.45, green: 0.85, blue: 0.80)

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    LinearGradient(stops: [
                        .init(color: Color(red: 0.55, green: 0.75, blue: 0.85), location: 0),
                        .init(color: Color(red: 0.80, green: 0.85, blue: 0.85), location: 0.42),
                        .init(color: Color(red: 0.10, green: 0.35, blue: 0.45), location: 0.46),
                        .init(color: Color(red: 0.05, green: 0.22, blue: 0.32), location: 1),
                    ], startPoint: .top, endPoint: .bottom)

                    // afternoon sun, hazy
                    Circle().fill(RadialGradient(colors: [.white.opacity(0.7), .clear],
                                                 center: .center, startRadius: 6, endRadius: 80))
                        .frame(width: 160, height: 160)
                        .position(x: w * 0.24, y: h * 0.16)

                    // three swell lines rolling in, whitecaps on the near one
                    swell(w: w, h: h, base: 0.52, amp: 5, phase: 0.5, alpha: 0.15)
                    swell(w: w, h: h, base: 0.60, amp: 8, phase: 2.6, alpha: 0.25)
                    swell(w: w, h: h, base: 0.70, amp: 12, phase: 4.4, alpha: 0.45)
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            VStack {
                HStack {
                    hudChip { Text("TOPANGA POINT")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    hudChip { Text("74° water").font(.caption.weight(.semibold))
                        .foregroundStyle(seafoam) }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 0) {
                Grabber()
                Text("Clean, chest-high sets")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.top, 12)
                Text("Best window 4–6 PM as the tide drops.")
                    .font(.callout).foregroundStyle(.secondary).padding(.top, 2)

                // tide instrument: the actual curve of the day, "now" pinned on it
                VStack(alignment: .leading, spacing: 6) {
                    microLabel("Tide today")
                    GeometryReader { geo in
                        let w = geo.size.width, h = geo.size.height
                        let nowX: CGFloat = 0.58
                        ZStack {
                            tideCurve(w: w, h: h)
                                .stroke(.white.opacity(0.2), lineWidth: 2)
                            tideCurve(w: w, h: h)
                                .trim(from: 0, to: nowX)
                                .stroke(seafoam, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                                .shadow(color: seafoam.opacity(0.8), radius: 4)
                            Circle().fill(.white).frame(width: 9, height: 9)
                                .shadow(color: seafoam, radius: 5)
                                .position(tidePoint(w: w, h: h, t: nowX))
                            Text("now").font(.caption2.weight(.semibold))
                                .foregroundStyle(seafoam)
                                .position(x: tidePoint(w: w, h: h, t: nowX).x,
                                          y: tidePoint(w: w, h: h, t: nowX).y - 16)
                        }
                    }
                    .frame(height: 74)
                    HStack {
                        microLabel("High 4.9 ft · 11:02 AM", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                        Spacer()
                        microLabel("Low 0.8 ft · 5:41 PM", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                    }
                }
                .padding(.top, 22)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Tide falling from 4.9 foot high at 11 AM to 0.8 foot low at 5:41 PM")

                Grid(alignment: .leading, horizontalSpacing: 28, verticalSpacing: 14) {
                    GridRow {
                        fact("Swell", "3.2 ft")
                        fact("Period", "14 s")
                        fact("Wind", "4 kn off")
                    }
                }
                .padding(.top, 20)

                Button {} label: {
                    Label("Set dawn patrol alert", systemImage: "bell.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                }
                .background(seafoam, in: Capsule())
                .foregroundStyle(Color(red: 0.03, green: 0.15, blue: 0.18))
                .padding(.top, 20).padding(.bottom, 8)
            }
            .modifier(SheetSurface(fill: Color(red: 0.06, green: 0.14, blue: 0.19)))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func swell(w: CGFloat, h: CGFloat, base: CGFloat, amp: CGFloat,
                       phase: CGFloat, alpha: Double) -> some View {
        Path { p in
            var x: CGFloat = 0
            p.move(to: CGPoint(x: 0, y: h * base + sin(phase) * amp))
            while x <= w {
                p.addLine(to: CGPoint(x: x, y: h * base + sin((x / w) * 7 + phase) * amp))
                x += 6
            }
        }.stroke(.white.opacity(alpha), lineWidth: 2)
    }

    private func tidePoint(w: CGFloat, h: CGFloat, t: CGFloat) -> CGPoint {
        CGPoint(x: w * t, y: h * 0.5 - sin(t * 5.2 - 0.6) * h * 0.36)
    }
    private func tideCurve(w: CGFloat, h: CGFloat) -> Path {
        Path { p in
            p.move(to: tidePoint(w: w, h: h, t: 0))
            var t: CGFloat = 0
            while t <= 1 { p.addLine(to: tidePoint(w: w, h: h, t: t)); t += 0.02 }
        }
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            microLabel(label, tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            Text(value).font(.system(.title3, design: .rounded).weight(.semibold))
                .monospacedDigit()
        }.accessibilityElement(children: .combine)
    }
}

// ===========================================================================
// SCREEN 3 — COFFEE (editorial light canvas + brew instrument + drawn cup)
//   QUESTION: "what do I do right now in this brew?"  METAPHOR: a recipe card
//   clipped above the pour-over.  TEMP: warm.  STAGE: the cup itself.
// ===========================================================================

struct CoffeeScreen: View {
    private let roast = Color(red: 0.55, green: 0.34, blue: 0.20)
    private let paper = Color(red: 0.98, green: 0.96, blue: 0.93)
    private let fillLevel: CGFloat = 0.55   // brew progress = liquid in the cup

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                microLabel("V60 · Ethiopia Guji")
                Spacer()
                microLabel("Step 3 of 5", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            }
            .padding(.top, 12)

            // hero: the clock IS the answer mid-brew
            (Text("1:42").font(.system(size: 76, weight: .bold, design: .rounded))
             + Text(" / 3:00").font(.system(size: 30, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary))
                .monospacedDigit()
                .padding(.top, 10)
                .accessibilityLabel("1 minute 42 of 3 minutes")

            Text("Second pour — spiral out slowly to 180 g.")
                .font(.system(.title3, design: .serif))
                .padding(.top, 4)

            Spacer()

            // THE SCENE: the cup, drawn, filling with the actual brew progress
            ZStack {
                GeometryReader { geo in
                    let w = geo.size.width, h = geo.size.height
                    let cupW = w * 0.46, cupH = h * 0.72
                    let cupX = w / 2, topY = h * 0.18
                    ZStack {
                        // steam: two lazy curves
                        steam(x: cupX - 16, y: topY - 8)
                        steam(x: cupX + 14, y: topY - 16)
                        // cup body
                        CupShape()
                            .fill(.white)
                            .frame(width: cupW, height: cupH)
                            .position(x: cupX, y: topY + cupH / 2)
                        CupShape()
                            .stroke(roast.opacity(0.35), lineWidth: 1.5)
                            .frame(width: cupW, height: cupH)
                            .position(x: cupX, y: topY + cupH / 2)
                        // coffee fill: level = brew progress
                        CupShape()
                            .fill(LinearGradient(colors: [roast.opacity(0.85), roast],
                                                 startPoint: .top, endPoint: .bottom))
                            .frame(width: cupW, height: cupH)
                            .mask(
                                Rectangle()
                                    .frame(height: cupH * fillLevel)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                            )
                            .position(x: cupX, y: topY + cupH / 2)
                        // handle
                        Circle().stroke(roast.opacity(0.35), lineWidth: 1.5)
                            .frame(width: cupW * 0.34, height: cupW * 0.34)
                            .position(x: cupX + cupW * 0.58, y: topY + cupH * 0.42)
                    }
                }
            }
            .frame(height: 220)
            .accessibilityHidden(true)

            Spacer()

            // stage instrument: real phases, current dimming
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    stage("Bloom", done: true)
                    stage("Pour 1", done: true)
                    stage("Pour 2", current: true)
                    stage("Drawdown")
                    stage("Serve")
                }
                HStack(spacing: 6) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(i <= 2 ? AnyShapeStyle(roast) : AnyShapeStyle(roast.opacity(0.15)))
                            .frame(height: 4)
                    }
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Brew stage 3 of 5, second pour")

            Button {} label: {
                Label("Done pouring — start drawdown", systemImage: "arrow.right")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
            }
            .background(roast, in: Capsule())
            .foregroundStyle(paper)
            .padding(.top, 20)
        }
        .padding(24)
        .background(paper.ignoresSafeArea())
        .foregroundStyle(Color(red: 0.20, green: 0.14, blue: 0.10))
        .preferredColorScheme(.light)
    }

    private func stage(_ name: String, done: Bool = false, current: Bool = false) -> some View {
        Text(name)
            .font(.caption2.weight(current ? .bold : .medium))
            .foregroundStyle(current ? AnyShapeStyle(roast) :
                             done ? AnyShapeStyle(.secondary) : AnyShapeStyle(.tertiary))
            .frame(maxWidth: .infinity)
    }

    private func steam(x: CGFloat, y: CGFloat) -> some View {
        Path { p in
            p.move(to: CGPoint(x: x, y: y))
            p.addQuadCurve(to: CGPoint(x: x + 6, y: y - 22),
                           control: CGPoint(x: x - 10, y: y - 12))
            p.addQuadCurve(to: CGPoint(x: x, y: y - 44),
                           control: CGPoint(x: x + 16, y: y - 34))
        }
        .stroke(Color(red: 0.55, green: 0.34, blue: 0.20).opacity(0.25),
                style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
}

struct CupShape: Shape {
    func path(in r: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: r.minX, y: r.minY))
            p.addLine(to: CGPoint(x: r.maxX, y: r.minY))
            p.addQuadCurve(to: CGPoint(x: r.maxX * 0.78, y: r.maxY),
                           control: CGPoint(x: r.maxX * 0.98, y: r.maxY * 0.75))
            p.addLine(to: CGPoint(x: r.maxX * 0.22, y: r.maxY))
            p.addQuadCurve(to: CGPoint(x: r.minX, y: r.minY),
                           control: CGPoint(x: r.maxX * 0.02, y: r.maxY * 0.75))
            p.closeSubpath()
        }
    }
}

// ===========================================================================
// SCREEN 4 — BREATHE (environmental dusk canvas + breathing-ring instrument)
//   QUESTION: "just breathe with me."  METAPHOR: ripples on still water at dusk.
//   TEMP: calm.  STAGE: the inside of an exhale.
// ===========================================================================

struct BreatheScreen: View {
    private let glow = Color(red: 0.75, green: 0.70, blue: 1.0)
    private let cycleProgress: CGFloat = 0.66   // 4s in / hold / 6s out

    var body: some View {
        ZStack {
            LinearGradient(stops: [
                .init(color: Color(red: 0.13, green: 0.10, blue: 0.28), location: 0),
                .init(color: Color(red: 0.20, green: 0.12, blue: 0.30), location: 0.6),
                .init(color: Color(red: 0.30, green: 0.16, blue: 0.30), location: 1),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    microLabel("Evening wind-down", tint: AnyShapeStyle(Color(white: 0.75)))
                    Spacer()
                    microLabel("4 of 10 breaths", tint: AnyShapeStyle(Color(white: 0.55)))
                }

                Spacer()

                // The instrument IS the scene: ripple rings + breath arc
                ZStack {
                    ForEach([1.0, 0.78, 0.56], id: \.self) { s in
                        Circle()
                            .stroke(glow.opacity(0.10 + (1 - s) * 0.15), lineWidth: 1.5)
                            .frame(width: 300 * s, height: 300 * s)
                    }
                    Circle()
                        .fill(RadialGradient(colors: [glow.opacity(0.35), .clear],
                                             center: .center, startRadius: 10, endRadius: 130))
                        .frame(width: 260, height: 260)
                    Circle()
                        .trim(from: 0, to: cycleProgress)
                        .stroke(glow, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 172, height: 172)
                        .shadow(color: glow.opacity(0.9), radius: 8)
                    VStack(spacing: 4) {
                        Text("Breathe out")
                            .font(.system(size: 26, weight: .semibold, design: .serif))
                        Text("slowly, through your nose")
                            .font(.footnote)
                            .foregroundStyle(Color(white: 0.7))
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Breathe out slowly, 4 seconds remaining in this breath")

                Spacer()

                // session dots: each breath is a real unit
                HStack(spacing: 8) {
                    ForEach(0..<10, id: \.self) { i in
                        Circle()
                            .fill(i < 4 ? AnyShapeStyle(glow) : AnyShapeStyle(.white.opacity(0.15)))
                            .frame(width: 6, height: 6)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Breath 4 of 10")

                Button("I'm done for tonight") {}
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.plain)
                    .foregroundStyle(Color(white: 0.65))
                    .padding(.top, 24)
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
