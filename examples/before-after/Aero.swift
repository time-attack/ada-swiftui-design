// EVAL APP 6 — "Aero", a weather app. Screen: forecast.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: "what's the sky doing to my plans today?"
//   METAPHOR: the sky itself is the interface (Lumy) — canvas = current conditions.
//   TEMPERATURE: calm, matter-of-fact.
import SwiftUI

@main
struct AeroApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        return Group { if after { A_Forecast() } else { B_Forecast() } }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Forecast: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Weather App 🌤️").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.blue, .cyan],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 180)
                    .overlay(VStack(spacing: 6) {
                        Text("☁️").font(.system(size: 60))
                        Text("72°F").font(.system(size: 44)).bold().foregroundColor(.white)
                        Text("Mostly Cloudy").foregroundColor(.white.opacity(0.9))
                    })
                    .shadow(radius: 8)

                HStack(spacing: 12) {
                    B_WBox(title: "Humidity", value: "68%", icon: "💧", color: .blue)
                    B_WBox(title: "Wind", value: "12 mph", icon: "💨", color: .green)
                    B_WBox(title: "UV Index", value: "6", icon: "☀️", color: .orange)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Hourly Forecast ⏰").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(["1PM ☀️ 72°", "2PM ⛅️ 73°", "3PM ☁️ 71°",
                                     "4PM 🌧 68°", "5PM 🌧 66°"], id: \.self) { h in
                                Text(h)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }

                Button(action: {}) {
                    Text("See 10-Day Forecast")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_WBox: View {
    let title: String, value: String, icon: String
    let color: Color
    var body: some View {
        VStack {
            Text(icon).font(.title2)
            Text(title).font(.caption)
            Text(value).font(.headline).foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.15)).cornerRadius(12)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

struct A_Hour: Identifiable {
    let id = UUID()
    let label: String, temp: Int
    let rain: Bool
    static let all = [
        A_Hour(label: "Now", temp: 72, rain: false),
        A_Hour(label: "2 PM", temp: 73, rain: false),
        A_Hour(label: "3 PM", temp: 71, rain: false),
        A_Hour(label: "4 PM", temp: 68, rain: true),
        A_Hour(label: "5 PM", temp: 66, rain: true),
        A_Hour(label: "6 PM", temp: 65, rain: true),
        A_Hour(label: "7 PM", temp: 64, rain: false),
    ]
}

// Procedural cloud layer: seeded LCG so the sky is stable between renders.
// Each cloud is a cluster of overlapping soft ellipses — no assets needed.
struct A_Clouds: View {
    let seed: UInt64
    let puffs: Int
    let tint: Color

    var body: some View {
        Canvas { ctx, size in
            var state = seed
            func rnd() -> CGFloat {
                state = state &* 6364136223846793005 &+ 1442695040888963407
                return CGFloat((state >> 33) % 1000) / 1000
            }
            for _ in 0..<puffs {
                let cx = rnd() * size.width * 1.2 - size.width * 0.1
                let cy = rnd() * size.height
                let w = 90 + rnd() * 170
                for _ in 0..<6 {
                    let ox = (rnd() - 0.5) * w * 0.9
                    let oy = (rnd() - 0.5) * w * 0.22
                    let ew = w * (0.40 + rnd() * 0.45)
                    let eh = ew * 0.52
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: cx + ox - ew / 2, y: cy + oy - eh / 2,
                                               width: ew, height: eh)),
                        with: .color(tint))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct A_Forecast: View {
    private let rainHue = Color(red: 0.45, green: 0.68, blue: 0.95)

    var body: some View {
        ZStack {
            // Overcast-afternoon sky, pre-rain: steel grays sliding cooler toward evening
            LinearGradient(stops: [
                .init(color: Color(red: 0.55, green: 0.60, blue: 0.68), location: 0),
                .init(color: Color(red: 0.42, green: 0.47, blue: 0.57), location: 0.55),
                .init(color: Color(red: 0.30, green: 0.35, blue: 0.47), location: 1),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            // THE SCENE — the sky the numbers are describing, drawn for real:
            // a hazy sun losing to two parallax layers of cloud (far = small/faint,
            // near = big/bold). "Mostly cloudy" is visible before it is readable.
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [.white.opacity(0.55), .clear],
                                             center: .center, startRadius: 8, endRadius: 130))
                        .frame(width: 260, height: 260)
                        .position(x: geo.size.width * 0.78, y: geo.size.height * 0.10)
                    A_Clouds(seed: 11, puffs: 4, tint: .white.opacity(0.10))
                        .frame(height: geo.size.height * 0.30)
                        .offset(y: geo.size.height * 0.02)
                    A_Clouds(seed: 4, puffs: 3, tint: .white.opacity(0.20))
                        .frame(height: geo.size.height * 0.24)
                        .offset(y: geo.size.height * 0.10)
                }
            }
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Bell Canyon · Mostly cloudy")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.white.opacity(0.75))

                (Text("72").font(.system(size: 104, weight: .bold, design: .rounded))
                 + Text("°").font(.system(size: 52, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6)))
                    .monospacedDigit()
                    .accessibilityLabel("72 degrees, mostly cloudy")

                // The forecast as advice, not a data dump
                Text("Rain rolls in around 4 PM — take a jacket tonight.")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.top, 2)

                Spacer().frame(height: 34)

                // Hourly: temperature as bar height, rain hours tinted — form follows data
                VStack(alignment: .leading, spacing: 10) {
                    Text("This afternoon")
                        .font(.caption.smallCaps())
                        .kerning(1.0)
                        .foregroundStyle(.white.opacity(0.55))
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(A_Hour.all) { h in
                            VStack(spacing: 6) {
                                Text("\(h.temp)°")
                                    .font(.caption.weight(.semibold))
                                    .monospacedDigit()
                                    .foregroundStyle(.white.opacity(0.9))
                                Capsule()
                                    .fill(h.rain ? rainHue : Color.white.opacity(0.35))
                                    .frame(height: CGFloat(h.temp - 55) * 6)
                                if h.rain {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 9))
                                        .foregroundStyle(rainHue)
                                } else {
                                    Spacer().frame(height: 11)
                                }
                                Text(h.label)
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.55))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Hourly forecast: low seventies until 3 PM, rain from 4 to 6 PM, cooling to 64 by 7")
                }

                Spacer()

                // The facts cluster: quiet, aligned, no boxes
                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 16) {
                    GridRow {
                        fact("High", "74°")
                        fact("Low", "58°")
                        fact("Wind", "12 mph")
                        fact("Humidity", "68%")
                    }
                }

                Spacer().frame(height: 24)

                Button("Next 10 days") {}
                    .font(.subheadline.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundStyle(.white.opacity(0.75))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.12), in: Capsule())
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption.smallCaps())
                .kerning(1.0)
                .foregroundStyle(.white.opacity(0.55))
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}
