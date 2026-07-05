// BRIEF: "Build a SwiftUI screen for a parking meter timer."
// VARIANT: ada — skill applied.
// QUESTION: "will I make it back before it runs out?"
// METAPHOR: the mechanical parking meter itself — needle, arc window, coin ticks.
// TEMPERATURE: urgent-calm.  STAGE: an instrument (the meter head), honestly chosen.
import SwiftUI

@main
struct ParkingApp: App {
    var body: some Scene { WindowGroup { MeterView() } }
}

struct MeterView: View {
    private let amber = Color(red: 1.00, green: 0.72, blue: 0.25)
    private let remaining: CGFloat = 0.40   // 48 of 120 min

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Zone 4B · Spot 112")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(amber).frame(width: 7, height: 7)
                    Text("Running low")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(amber)
                }
            }
            .padding(.top, 12)

            Spacer()

            // THE INSTRUMENT: a meter head — 180° arc window, needle at the
            // real remaining fraction, EXPIRED zone etched in red.
            ZStack {
                Canvas { ctx, size in
                    let c = CGPoint(x: size.width / 2, y: size.height * 0.78)
                    let r = size.width * 0.42
                    // arc ticks: every 10 min across 2h window
                    for i in 0...12 {
                        let frac = Double(i) / 12.0
                        let ang = Double.pi + frac * Double.pi
                        let major = i % 3 == 0
                        let inner = r - (major ? 20 : 11)
                        var p = Path()
                        p.move(to: CGPoint(x: c.x + cos(ang) * inner, y: c.y + sin(ang) * inner))
                        p.addLine(to: CGPoint(x: c.x + cos(ang) * r, y: c.y + sin(ang) * r))
                        // first 15% of window = red EXPIRED side (left)
                        let danger = frac < 0.13
                        ctx.stroke(p, with: .color(danger ? Color(red: 0.95, green: 0.35, blue: 0.30)
                                                          : .white.opacity(frac <= 0.40 ? 0.9 : 0.25)),
                                   lineWidth: major ? 3 : 1.5)
                    }
                    // needle at remaining fraction (right→left as time drains)
                    let nAng = Double.pi + 0.40 * Double.pi
                    var needle = Path()
                    needle.move(to: c)
                    needle.addLine(to: CGPoint(x: c.x + cos(nAng) * (r - 26),
                                               y: c.y + sin(nAng) * (r - 26)))
                    ctx.stroke(needle, with: .color(Color(red: 1.0, green: 0.72, blue: 0.25)),
                               style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                    ctx.fill(Path(ellipseIn: CGRect(x: c.x - 7, y: c.y - 7, width: 14, height: 14)),
                             with: .color(Color(red: 1.0, green: 0.72, blue: 0.25)))
                }
                .frame(height: 230)

                VStack(spacing: 2) {
                    Text("48:12")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Text("expires 3:42 PM")
                        .font(.footnote)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .offset(y: 64)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("48 minutes 12 seconds left, meter expires at 3:42 PM")

            Spacer()

            Text("Your walk back is about 12 minutes — extend before 3:30.")
                .font(.callout)
                .foregroundStyle(.secondary)

            Spacer().frame(height: 22)

            Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 14) {
                GridRow {
                    fact("Rate", "$2 /hr")
                    fact("Spent", "$2.40")
                    fact("Max", "2h 00m")
                }
            }

            Spacer().frame(height: 22)

            Button {} label: {
                Label("Add 30 min · $1.00", systemImage: "plus")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(amber, in: Capsule())
            .foregroundStyle(Color(red: 0.12, green: 0.08, blue: 0.02))

            Button("End session") {}
                .font(.subheadline.weight(.medium))
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .padding(24)
        .background(Color(red: 0.06, green: 0.06, blue: 0.08).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption.smallCaps()).kerning(1.0).foregroundStyle(.tertiary)
            Text(value).font(.system(.title3, design: .rounded).weight(.semibold)).monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}
