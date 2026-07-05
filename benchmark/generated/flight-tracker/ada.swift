// BRIEF: "Build a SwiftUI screen for a flight tracker."
// VARIANT: ada — skill applied.
// QUESTION: "is my flight on time?"
// METAPHOR: the night hemisphere the flight is actually crossing.
// TEMPERATURE: urgent-calm.  STAGE: architecture A — full-bleed world + sheet.
import SwiftUI

@main
struct FlightApp: App {
    var body: some Scene { WindowGroup { FlightDetail() } }
}

private let tarmac = Color(red: 0.04, green: 0.05, blue: 0.09)
private let sheetFill = Color(red: 0.10, green: 0.11, blue: 0.16)
private let onTime = Color(red: 0.30, green: 0.85, blue: 0.55)

struct FlightWorld: View {
    let accent: Color
    let progress: CGFloat

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let center = CGPoint(x: w * 0.50, y: h * 0.46)
            let r = w * 0.78
            let a = CGPoint(x: center.x - r * 0.60, y: center.y + r * 0.33)
            let b = CGPoint(x: center.x + r * 0.63, y: center.y - r * 0.22)
            let c = CGPoint(x: (a.x + b.x) / 2, y: min(a.y, b.y) - r * 0.42)
            let t = progress
            let planeX = (1-t)*(1-t)*a.x + 2*(1-t)*t*c.x + t*t*b.x
            let planeY = (1-t)*(1-t)*a.y + 2*(1-t)*t*c.y + t*t*b.y
            let dx = 2*(1-t)*(c.x-a.x) + 2*t*(b.x-c.x)
            let dy = 2*(1-t)*(c.y-a.y) + 2*t*(b.y-c.y)

            ZStack {
                Canvas { ctx, size in
                    var state: UInt64 = 9
                    func rnd() -> CGFloat {
                        state = state &* 6364136223846793005 &+ 1442695040888963407
                        return CGFloat((state >> 33) % 1000) / 1000
                    }
                    for _ in 0..<110 {
                        let sr = 0.4 + rnd() * 1.2
                        ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width,
                                                        y: rnd() * size.height,
                                                        width: sr * 2, height: sr * 2)),
                                 with: .color(.white.opacity(0.12 + rnd() * 0.45)))
                    }
                }
                ZStack {
                    Circle().fill(RadialGradient(
                        colors: [Color(red: 0.15, green: 0.22, blue: 0.40),
                                 Color(red: 0.05, green: 0.08, blue: 0.16)],
                        center: UnitPoint(x: 0.38, y: 0.28),
                        startRadius: r * 0.10, endRadius: r * 1.15))
                    ForEach([1.0, 0.74, 0.48, 0.20], id: \.self) { f in
                        Ellipse().stroke(.white.opacity(0.08), lineWidth: 1)
                            .frame(width: 2 * r * f, height: 2 * r)
                    }
                    ForEach([-0.5, -0.25, 0.0, 0.25, 0.5], id: \.self) { lat in
                        let lw = 2 * r * sqrt(max(0.001, 1 - lat * lat))
                        Ellipse().stroke(.white.opacity(0.08), lineWidth: 1)
                            .frame(width: lw, height: lw * 0.20)
                            .offset(y: r * lat)
                    }
                    Circle().stroke(.white.opacity(0.16), lineWidth: 1)
                }
                .frame(width: 2 * r, height: 2 * r)
                .position(center)

                Circle().stroke(accent.opacity(0.16), lineWidth: 10)
                    .blur(radius: 14)
                    .frame(width: 2 * r, height: 2 * r)
                    .position(center)

                Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
                    .stroke(.white.opacity(0.28),
                            style: StrokeStyle(lineWidth: 1.5, dash: [3, 5]))
                Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
                    .trim(from: 0, to: t)
                    .stroke(accent, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .shadow(color: accent.opacity(0.9), radius: 5)

                Circle().fill(.white).frame(width: 7, height: 7).position(a)
                Circle().stroke(accent, lineWidth: 2).frame(width: 11, height: 11).position(b)
                Text("TPE").font(.caption2.weight(.bold)).kerning(1.2)
                    .foregroundStyle(.white.opacity(0.65))
                    .position(x: a.x + 2, y: a.y + 18)
                Text("LAX").font(.caption2.weight(.bold)).kerning(1.2)
                    .foregroundStyle(accent)
                    .position(x: b.x - 6, y: b.y - 17)

                Image(systemName: "airplane")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: accent.opacity(0.9), radius: 7)
                    .rotationEffect(.radians(Double(atan2(dy, dx))))
                    .position(x: planeX, y: planeY)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Night route map: 65 percent of the way from Taipei to Los Angeles")
    }
}

struct FlightDetail: View {
    private let progress: CGFloat = 0.65

    var body: some View {
        ZStack(alignment: .bottom) {
            FlightWorld(accent: onTime, progress: progress)
                .background(tarmac)
                .ignoresSafeArea()

            VStack {
                HStack {
                    chip { Text("BR 12 · EVA AIR")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    chip {
                        HStack(spacing: 5) {
                            Circle().fill(onTime).frame(width: 7, height: 7)
                            Text("On time").font(.caption.weight(.semibold)).foregroundStyle(onTime)
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 0) {
                Capsule().fill(.white.opacity(0.25))
                    .frame(width: 36, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                Text("Lands 4:52 PM")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 14)
                Text("4h 06m remaining · over the Pacific")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                VStack(spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("TPE").font(.title3.weight(.bold))
                            Text("9:40 AM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("11h 45m")
                            .font(.caption.smallCaps().weight(.medium))
                            .kerning(1.0).monospacedDigit()
                            .foregroundStyle(.tertiary)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 1) {
                            Text("LAX").font(.title3.weight(.bold))
                            Text("4:52 PM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                    GeometryReader { geo in
                        let x = geo.size.width * progress
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.10)).frame(height: 5)
                            Capsule()
                                .fill(LinearGradient(colors: [onTime.opacity(0.25), onTime],
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(width: x, height: 5)
                                .shadow(color: onTime.opacity(0.8), radius: 5)
                            Circle().stroke(.white.opacity(0.35), lineWidth: 1.5)
                                .frame(width: 9, height: 9)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Image(systemName: "airplane")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .shadow(color: onTime.opacity(0.9), radius: 5)
                                .offset(x: x - 7)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 20)
                }
                .padding(.top, 22)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Taipei 9:40 AM to Los Angeles 4:52 PM, 65 percent flown")

                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 16) {
                    GridRow {
                        fact("Gate", "42B")
                        fact("Terminal", "7")
                        fact("Seat", "14A")
                    }
                    GridRow {
                        fact("Aircraft", "77W")
                        fact("Boarded", "9:05 AM")
                        fact("Baggage", "4")
                    }
                }
                .padding(.top, 22)

                Button {} label: {
                    Label("Share arrival time", systemImage: "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(.white, in: Capsule())
                .foregroundStyle(tarmac)
                .padding(.top, 22)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                    .fill(sheetFill)
                    .overlay(
                        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1))
                    .shadow(color: .black.opacity(0.55), radius: 24, y: -10)
                    .ignoresSafeArea(edges: .bottom))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func chip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.black.opacity(0.35), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption.smallCaps()).kerning(1.0).foregroundStyle(.tertiary)
            Text(value).font(.system(.title3, design: .rounded).weight(.semibold)).monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}
