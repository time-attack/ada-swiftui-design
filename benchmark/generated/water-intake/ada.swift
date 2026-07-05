// BRIEF: "Build a SwiftUI screen for a water-intake tracker."
// VARIANT: ada — ADA-Grade SwiftUI Design skill applied.
// QUESTION: "am I on track to hit 2L today?"
// METAPHOR: the glass on your desk — the water level IS the interface.
// TEMPERATURE: calm-clinical.  STAGE: the glass itself (instrument).
import SwiftUI

@main
struct WaterApp: App {
    var body: some Scene { WindowGroup { WaterView() } }
}

struct WaterView: View {
    private let aqua = Color(red: 0.30, green: 0.65, blue: 0.90)
    private let fill: CGFloat = 0.62

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Water · Saturday")
                .font(.subheadline.smallCaps().weight(.medium))
                .kerning(1.2)
                .foregroundStyle(.secondary)

            (Text("1.25").font(.system(size: 72, weight: .bold, design: .rounded))
             + Text(" L").font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary))
                .monospacedDigit()
                .padding(.top, 8)
                .accessibilityLabel("1.25 liters of 2 today")

            Text("0.75 L to go — you're usually done by 9 PM.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 2)

            Spacer()

            // THE INSTRUMENT: the day's glass, filled to the real level,
            // rippled surface, goal line etched where 2 L sits.
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let gw = w * 0.44, gh = h * 0.9
                let gx = w / 2, topY = (h - gh) / 2
                ZStack {
                    // water body
                    WaterShape(level: fill, wave: 6)
                        .fill(LinearGradient(colors: [aqua.opacity(0.75), aqua],
                                             startPoint: .top, endPoint: .bottom))
                        .frame(width: gw, height: gh)
                        .position(x: gx, y: topY + gh / 2)
                    // glass outline
                    GlassShape()
                        .stroke(.white.opacity(0.35), lineWidth: 2)
                        .frame(width: gw, height: gh)
                        .position(x: gx, y: topY + gh / 2)
                    // goal etch line at 100%
                    Rectangle().fill(.white.opacity(0.4))
                        .frame(width: gw * 0.7, height: 1.5)
                        .position(x: gx, y: topY + gh * 0.06)
                    Text("2 L")
                        .font(.caption2.weight(.semibold)).monospacedDigit()
                        .foregroundStyle(.white.opacity(0.5))
                        .position(x: gx + gw * 0.48, y: topY + gh * 0.06)
                }
            }
            .frame(height: 250)
            .accessibilityHidden(true)

            Spacer()

            // Day timeline: each sip is a real tick at its real hour
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's sips")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.10)).frame(height: 3)
                        ForEach([0.09, 0.22, 0.35, 0.46, 0.60], id: \.self) { t in
                            Circle().fill(aqua)
                                .frame(width: 9, height: 9)
                                .shadow(color: aqua.opacity(0.8), radius: 4)
                                .offset(x: geo.size.width * t - 4)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .frame(height: 16)
                HStack {
                    Text("7 AM").font(.caption2).foregroundStyle(.tertiary)
                    Spacer()
                    Text("10 PM").font(.caption2).foregroundStyle(.tertiary)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Five sips so far, last at 3:10 PM")

            Button {} label: {
                Label("Log a glass · 250 ml", systemImage: "drop.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(aqua, in: Capsule())
            .foregroundStyle(Color(red: 0.02, green: 0.10, blue: 0.16))
            .padding(.top, 20)
        }
        .padding(24)
        .background(
            LinearGradient(stops: [
                .init(color: Color(red: 0.04, green: 0.09, blue: 0.14), location: 0),
                .init(color: Color(red: 0.03, green: 0.06, blue: 0.10), location: 1),
            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}

// Tapered glass silhouette
struct GlassShape: Shape {
    func path(in r: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: r.minX, y: r.minY))
            p.addLine(to: CGPoint(x: r.maxX, y: r.minY))
            p.addLine(to: CGPoint(x: r.maxX * 0.86, y: r.maxY - 6))
            p.addQuadCurve(to: CGPoint(x: r.maxX * 0.14, y: r.maxY - 6),
                           control: CGPoint(x: r.midX, y: r.maxY + 6))
            p.closeSubpath()
        }
    }
}

// Water inside the tapered glass, with a gentle sine surface at `level`
struct WaterShape: Shape {
    var level: CGFloat
    var wave: CGFloat
    func path(in r: CGRect) -> Path {
        let surfaceY = r.maxY - 6 - (r.height - 6) * level
        func edgeX(_ y: CGFloat, left: Bool) -> CGFloat {
            let k = (y - r.minY) / r.height  // 0 top → 1 bottom
            let inset = r.width * 0.14 * k
            return left ? r.minX + inset : r.maxX - inset
        }
        return Path { p in
            p.move(to: CGPoint(x: edgeX(surfaceY, left: true), y: surfaceY))
            var x = edgeX(surfaceY, left: true)
            let xr = edgeX(surfaceY, left: false)
            while x <= xr {
                let ph = (x / r.width) * 4.5
                p.addLine(to: CGPoint(x: x, y: surfaceY + sin(ph) * wave * 0.4))
                x += 5
            }
            p.addLine(to: CGPoint(x: r.maxX * 0.86, y: r.maxY - 6))
            p.addQuadCurve(to: CGPoint(x: r.maxX * 0.14, y: r.maxY - 6),
                           control: CGPoint(x: r.midX, y: r.maxY + 6))
            p.closeSubpath()
        }
    }
}
