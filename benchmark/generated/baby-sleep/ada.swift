// BRIEF: "Build a SwiftUI screen for a baby sleep log."
// VARIANT: ada — skill applied.
// QUESTION: "did she get the sleep she needed today?"
// METAPHOR: standing in the nursery doorway after lights-out.
// TEMPERATURE: warm-calm, never judging.
// STAGE: the nursery night → environmental canvas + the day as one timeline band.
import SwiftUI

@main
struct BabyApp: App {
    var body: some Scene { WindowGroup { SleepLogView() } }
}

struct A_Session: Identifiable {
    let id = UUID()
    let name: String, range: String, duration: String
    let start: CGFloat, length: CGFloat   // fraction of the 24h band (8 AM → 8 AM)
    let isNight: Bool
    static let all = [
        A_Session(name: "Nap 1", range: "8:30 – 9:25 AM", duration: "55m",
                  start: 0.021, length: 0.038, isNight: false),
        A_Session(name: "Nap 2", range: "12:10 – 1:05 PM", duration: "55m",
                  start: 0.174, length: 0.038, isNight: false),
        A_Session(name: "Nap 3", range: "3:40 – 4:25 PM", duration: "45m",
                  start: 0.319, length: 0.031, isNight: false),
        A_Session(name: "Night", range: "8:10 PM – 4:55 AM", duration: "8h 45m",
                  start: 0.507, length: 0.365, isNight: true),
    ]
}

struct SleepLogView: View {
    private let lavender = Color(red: 0.75, green: 0.72, blue: 1.00)
    private let nightHue = Color(red: 0.45, green: 0.48, blue: 0.95)

    var body: some View {
        ZStack {
            // nursery night: soft indigo, a few dim stars, a small moon —
            // quiet enough to whisper over
            LinearGradient(stops: [
                .init(color: Color(red: 0.11, green: 0.10, blue: 0.24), location: 0),
                .init(color: Color(red: 0.15, green: 0.12, blue: 0.28), location: 0.6),
                .init(color: Color(red: 0.19, green: 0.14, blue: 0.30), location: 1),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            GeometryReader { geo in
                ZStack {
                    Canvas { ctx, size in
                        var state: UInt64 = 12
                        func rnd() -> CGFloat {
                            state = state &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((state >> 33) % 1000) / 1000
                        }
                        for _ in 0..<26 {
                            let r = 0.4 + rnd() * 0.9
                            ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width,
                                                            y: rnd() * size.height * 0.30,
                                                            width: r * 2, height: r * 2)),
                                     with: .color(.white.opacity(0.08 + rnd() * 0.22)))
                        }
                    }
                    ZStack {
                        Circle().fill(Color(red: 0.93, green: 0.91, blue: 0.84))
                        Circle().offset(x: 15, y: -6).blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .frame(width: 52, height: 52)
                    .shadow(color: .white.opacity(0.25), radius: 14)
                    .position(x: geo.size.width * 0.84, y: geo.size.height * 0.10)
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 0) {
                Text("Mila · Saturday")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(lavender)

                (Text("11").font(.system(size: 84, weight: .bold, design: .rounded))
                 + Text("h ").font(.system(size: 36, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                 + Text("20").font(.system(size: 84, weight: .bold, design: .rounded))
                 + Text("m").font(.system(size: 36, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary))
                    .padding(.top, 4)
                    .accessibilityLabel("11 hours 20 minutes of sleep today")

                Text("Three good naps and a solid night. A gentle day.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer().frame(height: 34)

                // THE INSTRUMENT: her whole day as one band, 8 AM to 8 AM —
                // sleep drawn where it actually happened
                VStack(alignment: .leading, spacing: 8) {
                    Text("Her day")
                        .font(.caption.smallCaps())
                        .kerning(1.0)
                        .foregroundStyle(.tertiary)
                    GeometryReader { geo in
                        let w = geo.size.width
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.08)).frame(height: 26)
                            ForEach(A_Session.all) { s in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(s.isNight ? nightHue : lavender)
                                    .frame(width: max(10, w * s.length), height: 26)
                                    .offset(x: w * s.start)
                                    .shadow(color: (s.isNight ? nightHue : lavender).opacity(0.6),
                                            radius: 4)
                            }
                        }
                    }
                    .frame(height: 26)
                    HStack {
                        Text("8 AM").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                        Spacer()
                        Text("8 PM").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                        Spacer()
                        Text("8 AM").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Sleep timeline: three naps across the day and night sleep from 8:10 PM to 4:55 AM")

                Spacer().frame(height: 26)

                // legend rows: hue + name + tabular durations
                VStack(spacing: 0) {
                    ForEach(A_Session.all) { s in
                        HStack(spacing: 10) {
                            Circle().fill(s.isNight ? nightHue : lavender)
                                .frame(width: 8, height: 8)
                            Text(s.name).font(.subheadline.weight(.medium))
                            Text(s.range).font(.caption).monospacedDigit()
                                .foregroundStyle(.tertiary)
                            Spacer()
                            Text(s.duration)
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 10)
                        .accessibilityElement(children: .combine)
                        if s.id != A_Session.all.last?.id {
                            Divider().opacity(0.3).padding(.leading, 18)
                        }
                    }
                }

                Spacer()

                Button {} label: {
                    Label("Start sleep timer", systemImage: "moon.zzz.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(lavender, in: Capsule())
                .foregroundStyle(Color(red: 0.10, green: 0.08, blue: 0.22))
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
