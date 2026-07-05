// BRIEF: "Build a SwiftUI screen for a pomodoro focus session."
// VARIANT: ada — skill applied.
// QUESTION: "how much focus is left in this block?"
// METAPHOR: a kitchen timer you can feel ticking — 25 physical minute-ticks.
// TEMPERATURE: clinical-warm.  STAGE: an instrument (the focus ring), honestly
// chosen — a pomodoro has no place, it has a mechanism.
import SwiftUI

@main
struct PomodoroApp: App {
    var body: some Scene { WindowGroup { PomodoroView() } }
}

struct PomodoroView: View {
    private let focusRed = Color(red: 0.95, green: 0.35, blue: 0.30)
    private let elapsed: CGFloat = 0.32   // 8 of 25 minutes gone

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Focus · block 3 of 4")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(focusRed).frame(width: 7, height: 7)
                    Text("Running")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(focusRed)
                }
            }
            .padding(.top, 12)

            Spacer()

            // THE INSTRUMENT: 25 ticks, one per minute of the block.
            // Elapsed minutes burn red; the current minute glows brightest.
            ZStack {
                Canvas { ctx, size in
                    let c = CGPoint(x: size.width / 2, y: size.height / 2)
                    let r = min(size.width, size.height) / 2 - 12
                    for i in 0..<25 {
                        let frac = Double(i) / 25.0
                        let ang = frac * 2 * .pi - .pi / 2
                        let isMajor = i % 5 == 0
                        let inner = r - (isMajor ? 20 : 12)
                        var p = Path()
                        p.move(to: CGPoint(x: c.x + cos(ang) * inner,
                                           y: c.y + sin(ang) * inner))
                        p.addLine(to: CGPoint(x: c.x + cos(ang) * r,
                                              y: c.y + sin(ang) * r))
                        let done = frac < 0.32
                        let current = i == 8
                        ctx.stroke(p,
                            with: .color(current ? Color(red: 1.0, green: 0.55, blue: 0.45)
                                        : done ? Color(red: 0.95, green: 0.35, blue: 0.30)
                                        : Color.white.opacity(0.15)),
                            lineWidth: isMajor ? 3.5 : 2)
                    }
                }

                VStack(spacing: 4) {
                    Text("17:03")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Text("until your 5-min break")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 290, height: 290)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("17 minutes 3 seconds of focus remaining, 8 minutes elapsed")

            Spacer()

            // Human sentence, on your side — and the task, quiet
            Text("A third down — the essay outline is all this block is for.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 24)

            // Session dots: each block is a real unit; done burn solid,
            // current rings, future stay hollow
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(i < 2 ? AnyShapeStyle(focusRed) : AnyShapeStyle(.clear))
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle().stroke(
                                i == 2 ? focusRed : Color.white.opacity(0.25),
                                lineWidth: i == 2 ? 2 : 1.5)
                        )
                }
                Text("2 done · this is block 3")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.leading, 6)
                Spacer()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("2 of 4 blocks done, block 3 running")

            Spacer().frame(height: 24)

            Button {} label: {
                Label("Pause", systemImage: "pause.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(focusRed, in: Capsule())
            .foregroundStyle(Color(red: 0.10, green: 0.03, blue: 0.03))
            .sensoryFeedback(.impact(weight: .light), trigger: true)

            Button("End the day's focus") {}
                .font(.subheadline.weight(.medium))
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .padding(24)
        .background(Color(red: 0.06, green: 0.05, blue: 0.06).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
