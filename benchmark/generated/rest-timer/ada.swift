// BRIEF: "Build a SwiftUI screen for a workout rest timer."
// VARIANT: ada — skill applied.
// QUESTION: "when do I lift again, and what am I lifting?"
// METAPHOR: a boxing-corner stopwatch — a coach's chronograph between rounds.
// TEMPERATURE: urgent-warm.  STAGE: instrument (the rest clock), honestly chosen.
import SwiftUI

@main
struct RestApp: App {
    var body: some Scene { WindowGroup { RestView() } }
}

struct RestView: View {
    private let ember = Color(red: 1.00, green: 0.45, blue: 0.25)
    private let remaining: CGFloat = 49.0 / 90.0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Pull day · Squats")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Set 3 of 5")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
            }
            .padding(.top, 12)

            Spacer()

            // THE INSTRUMENT: 18 ticks = 90 seconds in 5s steps; burnt ticks go quiet
            ZStack {
                Canvas { ctx, size in
                    let c = CGPoint(x: size.width / 2, y: size.height / 2)
                    let r = min(size.width, size.height) / 2 - 12
                    for i in 0..<18 {
                        let frac = Double(i) / 18.0
                        let ang = frac * 2 * .pi - .pi / 2
                        let major = i % 3 == 0
                        let inner = r - (major ? 20 : 12)
                        var p = Path()
                        p.move(to: CGPoint(x: c.x + cos(ang) * inner, y: c.y + sin(ang) * inner))
                        p.addLine(to: CGPoint(x: c.x + cos(ang) * r, y: c.y + sin(ang) * r))
                        let lit = frac < 49.0 / 90.0
                        ctx.stroke(p, with: .color(lit ? Color(red: 1.0, green: 0.45, blue: 0.25)
                                                       : .white.opacity(0.15)),
                                   lineWidth: major ? 4 : 2)
                    }
                }
                VStack(spacing: 4) {
                    Text("0:49")
                        .font(.system(size: 76, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Text("then 185 lb × 8")
                        .font(.footnote.weight(.medium))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 300, height: 300)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("49 seconds of rest left, then squats, 185 pounds for 8 reps")

            Spacer()

            Text("Last set moved fast — same weight, own the depth.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 20)

            // Set dots: each one a real set
            HStack(spacing: 10) {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill(i < 2 ? AnyShapeStyle(ember) :
                              i == 2 ? AnyShapeStyle(.white) : AnyShapeStyle(.quaternary))
                        .frame(width: i == 2 ? 12 : 8, height: i == 2 ? 12 : 8)
                }
                Spacer()
                Text("2 done")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Set 3 of 5, 2 completed")

            Spacer().frame(height: 22)

            HStack {
                Button("−15s") {}
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 18).padding(.vertical, 10)
                    .background(.white.opacity(0.08), in: Capsule())
                Button("+15s") {}
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 18).padding(.vertical, 10)
                    .background(.white.opacity(0.08), in: Capsule())
                Spacer()
                Button {} label: {
                    Label("Lift now", systemImage: "forward.end.fill")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 22).padding(.vertical, 13)
                }
                .background(ember, in: Capsule())
                .foregroundStyle(Color(red: 0.12, green: 0.04, blue: 0.02))
            }
            .padding(.bottom, 8)
        }
        .padding(24)
        .background(Color(red: 0.07, green: 0.05, blue: 0.05).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
