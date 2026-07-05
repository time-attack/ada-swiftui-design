// BRIEF: "Build a SwiftUI screen for tracking a road trip in progress."
// VARIANT: ada — skill applied.
// QUESTION: "are we making good time?"
// METAPHOR: the windshield at golden hour — the desert highway you're actually on.
// TEMPERATURE: warm, unhurried.
// STAGE: the road itself → architecture A: full-bleed world + sheet.
import SwiftUI

@main
struct TripApp: App {
    var body: some Scene { WindowGroup { TripView() } }
}

struct TripView: View {
    private let ember = Color(red: 1.00, green: 0.60, blue: 0.30)
    private let progress: CGFloat = 0.58

    var body: some View {
        ZStack(alignment: .bottom) {
            // LAYER 1 — the world: golden-hour desert, ridgelines, the road ahead
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let horizonY = h * 0.46
                let vp = CGPoint(x: w * 0.58, y: horizonY)   // vanishing point
                ZStack {
                    LinearGradient(stops: [
                        .init(color: Color(red: 0.28, green: 0.22, blue: 0.38), location: 0),
                        .init(color: Color(red: 0.75, green: 0.38, blue: 0.30), location: 0.34),
                        .init(color: Color(red: 0.98, green: 0.72, blue: 0.40), location: 0.46),
                        .init(color: Color(red: 0.30, green: 0.16, blue: 0.16), location: 0.47),
                        .init(color: Color(red: 0.16, green: 0.09, blue: 0.10), location: 1),
                    ], startPoint: .top, endPoint: .bottom)

                    // low sun on the horizon
                    Circle()
                        .fill(RadialGradient(colors: [Color(red: 1, green: 0.88, blue: 0.6),
                                                      Color(red: 1, green: 0.7, blue: 0.35).opacity(0.0)],
                                             center: .center, startRadius: 6, endRadius: 110))
                        .frame(width: 220, height: 220)
                        .position(x: w * 0.30, y: horizonY - 14)

                    // distant ridgelines
                    ridge(w: w, h: h, base: horizonY / h - 0.035, amp: 12, phase: 1.8,
                          color: Color(red: 0.45, green: 0.24, blue: 0.28))
                    ridge(w: w, h: h, base: horizonY / h - 0.012, amp: 8, phase: 4.9,
                          color: Color(red: 0.30, green: 0.15, blue: 0.18))

                    // the road: edges converging on the vanishing point
                    Path { p in
                        p.move(to: CGPoint(x: w * 0.10, y: h))
                        p.addLine(to: vp)
                        p.addLine(to: CGPoint(x: w * 0.94, y: h))
                        p.closeSubpath()
                    }
                    .fill(Color(red: 0.11, green: 0.09, blue: 0.12))

                    // centerline dashes, foreshortened by hand for perspective
                    ForEach(Array([0.97, 0.86, 0.76, 0.675, 0.605, 0.55, 0.51].enumerated()),
                            id: \.offset) { i, t in
                        let tt = CGFloat(t)
                        let x = w * 0.52 + (vp.x - w * 0.52) * (1 - (tt - horizonY / h) / (1 - horizonY / h))
                        let width = 3 + 8 * (tt - horizonY / h) / (1 - horizonY / h)
                        let height = 6 + 26 * (tt - horizonY / h) / (1 - horizonY / h)
                        Capsule()
                            .fill(Color(red: 0.95, green: 0.85, blue: 0.55).opacity(0.75))
                            .frame(width: width, height: height)
                            .position(x: x, y: h * tt)
                    }
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            // LAYER 2a — HUD chips in the world
            VStack {
                HStack {
                    hudChip { Text("VEGAS → LA · DAY 2")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    hudChip {
                        HStack(spacing: 5) {
                            Image(systemName: "fuelpump.fill").font(.system(size: 9))
                            Text("62%").font(.caption.weight(.semibold)).monospacedDigit()
                        }.foregroundStyle(ember)
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            // LAYER 2b — the sheet
            VStack(alignment: .leading, spacing: 0) {
                Capsule().fill(.white.opacity(0.25))
                    .frame(width: 36, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                Text("Arriving 6:45 PM")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 12)
                Text("186 mi to go · gas at Barstow in 45 mi")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                // the trip instrument: codes, glowing trail, car at 58%, fuel tick
                VStack(spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("LAS").font(.title3.weight(.bold))
                            Text("1:20 PM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("444 mi")
                            .font(.caption.smallCaps().weight(.medium))
                            .kerning(1.0).monospacedDigit()
                            .foregroundStyle(.tertiary)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 1) {
                            Text("LA").font(.title3.weight(.bold))
                            Text("6:45 PM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                    GeometryReader { geo in
                        let x = geo.size.width * progress
                        let fuelX = geo.size.width * 0.68   // Barstow
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.10)).frame(height: 5)
                            Capsule()
                                .fill(LinearGradient(colors: [ember.opacity(0.25), ember],
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(width: x, height: 5)
                                .shadow(color: ember.opacity(0.8), radius: 5)
                            // fuel-stop tick
                            Image(systemName: "fuelpump.fill")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.55))
                                .offset(x: fuelX - 4, y: -14)
                            Circle().stroke(.white.opacity(0.35), lineWidth: 1.5)
                                .frame(width: 9, height: 9)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Image(systemName: "car.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                                .shadow(color: ember.opacity(0.9), radius: 5)
                                .offset(x: x - 7)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 26)
                }
                .padding(.top, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("258 of 444 miles, car at 58 percent, fuel stop at Barstow ahead")

                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 14) {
                    GridRow {
                        fact("Speed", "72 mph")
                        fact("Left", "2h 51m")
                        fact("Fuel", "62%")
                    }
                }
                .padding(.top, 20)

                Button {} label: {
                    Label("Add a stop", systemImage: "plus")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(ember, in: Capsule())
                .foregroundStyle(Color(red: 0.14, green: 0.07, blue: 0.03))
                .padding(.top, 20).padding(.bottom, 8)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                    .fill(Color(red: 0.12, green: 0.09, blue: 0.10))
                    .overlay(
                        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1))
                    .shadow(color: .black.opacity(0.55), radius: 24, y: -10)
                    .ignoresSafeArea(edges: .bottom))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func ridge(w: CGFloat, h: CGFloat, base: CGFloat, amp: CGFloat,
                       phase: CGFloat, color: Color) -> some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: h * base + 30))
            p.addLine(to: CGPoint(x: 0, y: h * base))
            var x: CGFloat = 0
            while x <= w {
                p.addLine(to: CGPoint(x: x, y: h * base + sin((x / w) * 5.2 + phase) * amp))
                x += 8
            }
            p.addLine(to: CGPoint(x: w, y: h * base + 30))
            p.closeSubpath()
        }.fill(color)
    }

    private func hudChip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
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
