// EVAL APP 1 — "Drift", a sleep tracker. Screens: home, night detail.
// Variants: --before (typical LLM output) / --after (SKILL.md applied)
//
// AFTER design notes (Step 0):
//   QUESTION: "How did I sleep, and what should I do tonight?"
//   METAPHOR: a bedside window before dawn — the sky is the interface (Lumy).
//   TEMPERATURE: calm.
import SwiftUI

@main
struct DriftApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        let screen = (args.contains("--screen2") || env["EVAL_SCREEN"] == "2") ? 2 : 1
        return Group {
            if after {
                if screen == 1 { A_Home() } else { A_NightDetail() }
            } else {
                if screen == 1 { B_Home() } else { B_NightDetail() }
            }
        }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Home: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Welcome back, User! 👋").font(.title).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.purple, .blue],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 150)
                    .overlay(VStack {
                        Text("Sleep Score").font(.headline).foregroundColor(.white)
                        Text("87").font(.system(size: 48)).foregroundColor(.white)
                    })
                    .shadow(radius: 5)

                HStack(spacing: 12) {
                    B_Stat(icon: "😴", title: "Duration", value: "7h 42m", color: .green)
                    B_Stat(icon: "💤", title: "Quality", value: "Good", color: .orange)
                    B_Stat(icon: "🛏️", title: "In Bed", value: "8h 10m", color: .pink)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Nights").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(0..<4) { i in
                        HStack {
                            Text("🌙")
                            Text("Night \(i + 1)")
                            Spacer()
                            Text("7h 30m").foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("Start Sleep Tracking")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_Stat: View {
    let icon: String, title: String, value: String
    let color: Color
    var body: some View {
        VStack {
            Text(icon).font(.title)
            Text(title).font(.caption)
            Text(value).font(.headline)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.2)).cornerRadius(12)
    }
}

struct B_NightDetail: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Night Details 📊").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.indigo, .purple],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 120)
                    .overlay(VStack {
                        Text("Overall Score").foregroundColor(.white)
                        Text("87 / 100").font(.title).bold().foregroundColor(.white)
                    })
                    .shadow(radius: 5)

                HStack(spacing: 12) {
                    B_Stat(icon: "🌙", title: "Deep", value: "1h 12m", color: .blue)
                    B_Stat(icon: "✨", title: "REM", value: "1h 48m", color: .purple)
                    B_Stat(icon: "☀️", title: "Awake", value: "0h 14m", color: .yellow)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Hourly Breakdown").font(.headline)
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach([60, 90, 45, 80, 70, 95, 50], id: \.self) { v in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue)
                                .frame(height: CGFloat(v))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 100)
                }
                .padding().background(Color(.systemGray6)).cornerRadius(12)

                Button(action: {}) {
                    Text("View Full Report")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

private let driftAccent = Color(red: 0.72, green: 0.72, blue: 1.0)
private let driftInk = Color(red: 0.05, green: 0.04, blue: 0.15)

private var nightCanvas: LinearGradient {
    LinearGradient(stops: [
        .init(color: Color(red: 0.03, green: 0.03, blue: 0.10), location: 0),
        .init(color: Color(red: 0.07, green: 0.06, blue: 0.20), location: 0.55),
        .init(color: Color(red: 0.25, green: 0.15, blue: 0.30), location: 1),
    ], startPoint: .top, endPoint: .bottom)
}

struct A_Home: View {
    var body: some View {
        ZStack {
            nightCanvas.ignoresSafeArea()

            // THE SCENE — last night, still hanging in the sky: seeded star field
            // and a crescent moon (a circle with a bite punched out via
            // destinationOut). The screen is a bedside window, so draw the night.
            GeometryReader { geo in
                ZStack {
                    Canvas { ctx, size in
                        var state: UInt64 = 7
                        func rnd() -> CGFloat {
                            state = state &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((state >> 33) % 1000) / 1000
                        }
                        for _ in 0..<70 {
                            let r = 0.4 + rnd() * 1.1
                            let y = rnd() * size.height * 0.45
                            ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width, y: y,
                                                            width: r * 2, height: r * 2)),
                                     with: .color(.white.opacity(0.12 + rnd() * 0.4)))
                        }
                    }
                    ZStack {
                        Circle().fill(Color(red: 0.93, green: 0.91, blue: 0.82))
                        Circle()
                            .offset(x: 24, y: -9)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .frame(width: 84, height: 84)
                    .shadow(color: .white.opacity(0.30), radius: 22)
                    .position(x: geo.size.width * 0.80, y: geo.size.height * 0.15)
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 0) {
                Text("Slept last night")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .foregroundStyle(driftAccent)
                    .kerning(1.2)

                (Text("7").font(.system(size: 92, weight: .bold, design: .rounded))
                 + Text("h ").font(.system(size: 38, weight: .medium, design: .rounded)).foregroundStyle(.secondary)
                 + Text("42").font(.system(size: 92, weight: .bold, design: .rounded))
                 + Text("m").font(.system(size: 38, weight: .medium, design: .rounded)).foregroundStyle(.secondary))
                    .accessibilityLabel("Slept 7 hours 42 minutes last night")

                Text("Asleep by 11:04 — earlier than usual. Nice.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer().frame(height: 30)

                Grid(alignment: .leading, horizontalSpacing: 26, verticalSpacing: 14) {
                    GridRow {
                        A_Metric(label: "Bedtime", value: "11:04", unit: "PM")
                        A_Metric(label: "Woke", value: "6:46", unit: "AM")
                        A_Metric(label: "Restful", value: "82", unit: "%")
                    }
                }

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Last 7 nights")
                        .font(.caption.smallCaps())
                        .foregroundStyle(.tertiary)
                        .kerning(1.0)
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(A_Night.week) { n in
                            VStack(spacing: 6) {
                                Capsule()
                                    .fill(n.isBest ? AnyShapeStyle(driftAccent) : AnyShapeStyle(.quaternary))
                                    .frame(width: 26, height: n.hours * 10)
                                Text(n.day).font(.caption2).foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Sleep for the last 7 nights, best night Saturday, 8.2 hours")
                }

                Spacer().frame(height: 26)

                Button {} label: {
                    Label("Wind down", systemImage: "moon.stars.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(driftAccent, in: Capsule())
                .foregroundStyle(driftInk)
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}

struct A_Metric: View {
    let label: String, value: String, unit: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption.smallCaps())
                .foregroundStyle(.tertiary)
                .kerning(1.0)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .monospacedDigit()
                Text(unit).font(.caption).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct A_Night: Identifiable {
    let id = UUID(); let day: String; let hours: Double; var isBest = false
    static let week = [
        A_Night(day: "M", hours: 6.2), A_Night(day: "T", hours: 7.1),
        A_Night(day: "W", hours: 5.8), A_Night(day: "T", hours: 7.4),
        A_Night(day: "F", hours: 6.9), A_Night(day: "S", hours: 8.2, isBest: true),
        A_Night(day: "S", hours: 7.7),
    ]
}

// Night detail: the night as a timeline. Phase = semantic hue, labeled, never color-only.
struct A_Phase: Identifiable {
    let id = UUID()
    let name: String, minutes: Int
    let hue: Color
    static let phases = [
        A_Phase(name: "Awake", minutes: 14, hue: Color(red: 1.00, green: 0.72, blue: 0.35)),
        A_Phase(name: "REM", minutes: 108, hue: Color(red: 0.72, green: 0.72, blue: 1.00)),
        A_Phase(name: "Core", minutes: 268, hue: Color(red: 0.38, green: 0.52, blue: 0.95)),
        A_Phase(name: "Deep", minutes: 72, hue: Color(red: 0.25, green: 0.30, blue: 0.65)),
    ]
}

struct A_NightDetail: View {
    private var total: Int { A_Phase.phases.reduce(0) { $0 + $1.minutes } }

    var body: some View {
        ZStack {
            nightCanvas.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Friday, July 4")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .foregroundStyle(driftAccent)
                    .kerning(1.2)

                (Text("7").font(.system(size: 64, weight: .bold, design: .rounded))
                 + Text("h ").font(.system(size: 30, weight: .medium, design: .rounded)).foregroundStyle(.secondary)
                 + Text("42").font(.system(size: 64, weight: .bold, design: .rounded))
                 + Text("m").font(.system(size: 30, weight: .medium, design: .rounded)).foregroundStyle(.secondary))
                    .accessibilityLabel("7 hours 42 minutes asleep")

                Text("Your deepest sleep came early — most Deep phase before 2 AM.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer().frame(height: 36)

                // The night, 11:04 PM → 6:46 AM, as one proportional band
                VStack(alignment: .leading, spacing: 8) {
                    Text("The night")
                        .font(.caption.smallCaps())
                        .foregroundStyle(.tertiary)
                        .kerning(1.0)

                    GeometryReader { geo in
                        HStack(spacing: 2) {
                            ForEach(A_Phase.phases) { p in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(p.hue)
                                    .frame(width: max(8, geo.size.width * CGFloat(p.minutes) / CGFloat(total)))
                            }
                        }
                    }
                    .frame(height: 34)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Sleep phases: 14 minutes awake, 1 hour 48 REM, 4 hours 28 core, 1 hour 12 deep")

                    HStack {
                        Text("11:04 PM").font(.caption2).foregroundStyle(.tertiary).monospacedDigit()
                        Spacer()
                        Text("6:46 AM").font(.caption2).foregroundStyle(.tertiary).monospacedDigit()
                    }
                }

                Spacer().frame(height: 30)

                // Legend rows: hue + name + duration, aligned and tabular
                VStack(spacing: 0) {
                    ForEach(A_Phase.phases) { p in
                        HStack(spacing: 10) {
                            Circle().fill(p.hue).frame(width: 8, height: 8)
                            Text(p.name).font(.subheadline.weight(.medium))
                            Spacer()
                            Text("\(p.minutes / 60)h \(p.minutes % 60, specifier: "%02d")m")
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                            Text("\(Int((Double(p.minutes) / Double(total) * 100).rounded()))%")
                                .font(.caption)
                                .monospacedDigit()
                                .foregroundStyle(.tertiary)
                                .frame(width: 38, alignment: .trailing)
                        }
                        .padding(.vertical, 10)
                        .accessibilityElement(children: .combine)
                        if p.id != A_Phase.phases.last?.id {
                            Divider().opacity(0.3)
                        }
                    }
                }

                Spacer()

                Button("Compare with July") {}
                    .font(.subheadline.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
