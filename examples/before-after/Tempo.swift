// EVAL APP 7 — "Tempo", a timer. Screen: running timer.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: "how much is left?"
//   METAPHOR: a mechanical chronograph — tick ring, mono digits, one orange hand.
//   TEMPERATURE: clinical-calm.
import SwiftUI

@main
struct TempoApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        return Group { if after { A_Timer() } else { B_Timer() } }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Timer: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Timer App ⏱️").font(.largeTitle).bold()

            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 16)
                Circle()
                    .trim(from: 0, to: 0.63)
                    .stroke(LinearGradient(colors: [.purple, .blue],
                                           startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("12:34").font(.system(size: 48)).bold()
                    Text("remaining ⏳").foregroundColor(.gray)
                }
            }
            .frame(width: 240, height: 240)
            .shadow(radius: 5)

            HStack(spacing: 12) {
                ForEach(["5 min", "10 min", "15 min", "30 min"], id: \.self) { p in
                    Button(p) {}
                        .padding(10)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }

            HStack {
                Button("Reset 🔄") {}
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.red).foregroundColor(.white).cornerRadius(10)
                Button("Pause ⏸") {}
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

struct A_Timer: View {
    private let accent = Color(red: 1.00, green: 0.55, blue: 0.20) // chronograph orange
    private let remaining: Double = 0.63 // fraction left of a 20-minute timer

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.07).ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Focus · 20 min")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                // Chronograph face: 60 physical ticks; elapsed arc stays quiet,
                // remaining ticks carry the accent — the ring IS the data.
                ZStack {
                    Canvas { context, size in
                        let center = CGPoint(x: size.width / 2, y: size.height / 2)
                        let radius = min(size.width, size.height) / 2 - 12
                        for i in 0..<60 {
                            let angle = (Double(i) / 60.0) * 2 * .pi - .pi / 2
                            let isMajor = i % 5 == 0
                            let inner = radius - (isMajor ? 18 : 10)
                            let p1 = CGPoint(x: center.x + cos(angle) * inner,
                                             y: center.y + sin(angle) * inner)
                            let p2 = CGPoint(x: center.x + cos(angle) * radius,
                                             y: center.y + sin(angle) * radius)
                            var path = Path()
                            path.move(to: p1)
                            path.addLine(to: p2)
                            let lit = Double(i) / 60.0 < remaining
                            context.stroke(path,
                                with: .color(lit ? Color(red: 1.00, green: 0.55, blue: 0.20)
                                                 : Color.white.opacity(0.15)),
                                lineWidth: isMajor ? 3 : 1.5)
                        }
                    }

                    VStack(spacing: 4) {
                        Text("12:34")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                        Text("ends at 10:02")
                            .font(.footnote)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 300, height: 300)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("12 minutes 34 seconds remaining, ends at 10:02")

                Spacer()

                // Presets recede while running — visible, not shouting
                HStack(spacing: 8) {
                    ForEach(["5", "10", "15", "30"], id: \.self) { p in
                        Text("\(p) min")
                            .font(.footnote.weight(.medium))
                            .monospacedDigit()
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(.white.opacity(0.06), in: Capsule())
                    }
                }

                Spacer().frame(height: 28)

                // One primary action; destructive stays quiet text
                Button {} label: {
                    Label("Pause", systemImage: "pause.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(accent, in: Capsule())
                .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.07))

                Button("Reset") {}
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
