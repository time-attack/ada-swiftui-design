// BRIEF: "Build a SwiftUI screen for tonight's moon phase."
// VARIANT: ada — skill applied.
// QUESTION: "what does the moon look like tonight, and when is it full?"
// METAPHOR: lying in the yard looking up — tonight's sky IS the screen.
// TEMPERATURE: quiet wonder.  STAGE: architecture A — full-bleed night world
// (star field + the moon DRAWN at its real phase) with facts on a bottom sheet.
import SwiftUI

@main
struct MoonApp: App {
    var body: some Scene { WindowGroup { MoonView() } }
}

struct MoonView: View {
    private let moonlight = Color(red: 0.84, green: 0.86, blue: 0.95)
    private let cream = Color(red: 0.93, green: 0.91, blue: 0.82)

    var body: some View {
        ZStack(alignment: .bottom) {
            // LAYER 1 — the world: night sky, seeded stars, the moon at its
            // actual waxing-gibbous phase, treeline on the horizon.
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let horizonY = h * 0.72
                ZStack {
                    LinearGradient(stops: [
                        .init(color: Color(red: 0.02, green: 0.03, blue: 0.09), location: 0),
                        .init(color: Color(red: 0.06, green: 0.07, blue: 0.17), location: 0.6),
                        .init(color: Color(red: 0.10, green: 0.09, blue: 0.20), location: 1),
                    ], startPoint: .top, endPoint: .bottom)

                    // stars — seeded so the sky is stable
                    Canvas { ctx, size in
                        var state: UInt64 = 13
                        func rnd() -> CGFloat {
                            state = state &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((state >> 33) % 1000) / 1000
                        }
                        for _ in 0..<130 {
                            let r = 0.4 + rnd() * 1.1
                            let y = rnd() * horizonY
                            ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width, y: y,
                                                            width: r * 2, height: r * 2)),
                                     with: .color(.white.opacity(0.12 + rnd() * 0.5)))
                        }
                    }

                    // THE MOON — waxing gibbous, 78% lit: bright disc with the
                    // shadow bite punched out of the left edge (destinationOut).
                    ZStack {
                        Circle().fill(cream)
                        // faint surface maria
                        Circle().fill(Color(red: 0.80, green: 0.78, blue: 0.68).opacity(0.55))
                            .frame(width: 34, height: 34).offset(x: -14, y: -20)
                        Circle().fill(Color(red: 0.80, green: 0.78, blue: 0.68).opacity(0.45))
                            .frame(width: 22, height: 22).offset(x: 18, y: 8)
                        Circle().fill(Color(red: 0.80, green: 0.78, blue: 0.68).opacity(0.5))
                            .frame(width: 16, height: 16).offset(x: -6, y: 26)
                        // shadow side: offset dark circle punches the unlit sliver
                        Circle()
                            .offset(x: -96)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .frame(width: 150, height: 150)
                    .shadow(color: cream.opacity(0.45), radius: 34)
                    .position(x: w * 0.62, y: h * 0.30)

                    // label pinned IN the world, beside the moon
                    Text("WAXING GIBBOUS")
                        .font(.caption2.weight(.bold))
                        .kerning(2.0)
                        .foregroundStyle(moonlight.opacity(0.8))
                        .position(x: w * 0.62, y: h * 0.30 + 106)

                    // treeline silhouette
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: h))
                        p.addLine(to: CGPoint(x: 0, y: horizonY))
                        var x: CGFloat = 0
                        while x <= w {
                            p.addLine(to: CGPoint(x: x, y: horizonY - abs(sin(x / 22)) * 9))
                            x += 8
                        }
                        p.addLine(to: CGPoint(x: w, y: h))
                        p.closeSubpath()
                    }.fill(Color(red: 0.03, green: 0.04, blue: 0.07))
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            // LAYER 2a — HUD chip
            VStack {
                HStack {
                    Text("TONIGHT · BELL CANYON")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color.black.opacity(0.35), in: Capsule())
                        .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
                    Spacer()
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            // LAYER 2b — the sheet: every fact on a surface, not in the sky
            VStack(alignment: .leading, spacing: 0) {
                Capsule().fill(.white.opacity(0.25))
                    .frame(width: 36, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                (Text("78%")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                 + Text(" illuminated")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary))
                    .monospacedDigit()
                    .padding(.top, 14)
                    .accessibilityLabel("78 percent illuminated tonight")

                Text("Growing every night — full moon Thursday, in 5 nights.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                // waxing timeline: tonight → full, each tick a real night
                HStack(spacing: 6) {
                    ForEach(0..<6, id: \.self) { i in
                        Capsule()
                            .fill(i == 0 ? AnyShapeStyle(moonlight) : AnyShapeStyle(.white.opacity(0.14)))
                            .frame(height: 4)
                    }
                }
                .padding(.top, 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("5 nights until the full moon")
                HStack {
                    Text("tonight").font(.caption2).foregroundStyle(moonlight)
                    Spacer()
                    Text("full · Jul 10").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                }
                .padding(.top, 4)

                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 14) {
                    GridRow {
                        fact("Moonrise", "6:42 PM")
                        fact("Moonset", "4:18 AM")
                        fact("Age", "10.3 d")
                    }
                }
                .padding(.top, 20)

                Button {} label: {
                    Label("Remind me at the full moon", systemImage: "bell.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(moonlight, in: Capsule())
                .foregroundStyle(Color(red: 0.05, green: 0.06, blue: 0.13))
                .padding(.top, 20)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                    .fill(Color(red: 0.09, green: 0.09, blue: 0.15))
                    .overlay(
                        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1))
                    .shadow(color: .black.opacity(0.55), radius: 24, y: -10)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption.smallCaps())
                .kerning(1.0)
                .foregroundStyle(.tertiary)
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}
