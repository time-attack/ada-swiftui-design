// EVAL APP 8 — "Vinyl", a music player. Screen: now playing.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: "what's playing, and where am I in it?"
//   METAPHOR: a record on a turntable — grooves, warm dark wood-lit room.
//   TEMPERATURE: warm-calm.
import SwiftUI

@main
struct VinylApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        return Group { if after { A_Player() } else { B_Player() } }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Player: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Now Playing 🎵").font(.largeTitle).bold()

            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.purple, .pink],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 260, height: 260)
                .overlay(Text("🎵").font(.system(size: 80)))
                .shadow(radius: 8)

            VStack(spacing: 4) {
                Text("Midnight Drive").font(.title2).bold()
                Text("The Nightowls").foregroundColor(.gray)
            }

            Slider(value: .constant(0.4))
                .padding(.horizontal)
            HStack {
                Text("1:24").font(.caption).foregroundColor(.gray)
                Spacer()
                Text("3:37").font(.caption).foregroundColor(.gray)
            }
            .padding(.horizontal)

            HStack(spacing: 20) {
                Button("⏮") {}.font(.title)
                    .padding().background(Color.blue.opacity(0.2)).clipShape(Circle())
                Button("▶️") {}.font(.title)
                    .padding().background(Color.blue).clipShape(Circle())
                Button("⏭") {}.font(.title)
                    .padding().background(Color.blue.opacity(0.2)).clipShape(Circle())
            }

            Spacer()
        }
        .padding(.top, 40)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

struct A_Player: View {
    private let amber = Color(red: 0.95, green: 0.65, blue: 0.30) // tonearm lamp
    private let progress: CGFloat = 0.38

    var body: some View {
        ZStack {
            // A dim listening room, not pure black
            LinearGradient(stops: [
                .init(color: Color(red: 0.10, green: 0.07, blue: 0.06), location: 0),
                .init(color: Color(red: 0.06, green: 0.05, blue: 0.05), location: 1),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Now spinning")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.4)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                // The record: concentric grooves drawn for real, label in the middle.
                ZStack {
                    Canvas { context, size in
                        let center = CGPoint(x: size.width / 2, y: size.height / 2)
                        let maxR = min(size.width, size.height) / 2
                        // grooves
                        var r = maxR
                        while r > maxR * 0.38 {
                            let rect = CGRect(x: center.x - r, y: center.y - r,
                                              width: r * 2, height: r * 2)
                            context.stroke(Path(ellipseIn: rect),
                                           with: .color(.white.opacity(r.truncatingRemainder(dividingBy: 9) < 2 ? 0.10 : 0.05)),
                                           lineWidth: 0.8)
                            r -= 2.6
                        }
                        // disc edge
                        context.stroke(
                            Path(ellipseIn: CGRect(x: center.x - maxR, y: center.y - maxR,
                                                   width: maxR * 2, height: maxR * 2)),
                            with: .color(.white.opacity(0.25)), lineWidth: 1.5)
                    }

                    // Label: album identity, one warm hue
                    Circle()
                        .fill(amber.opacity(0.9))
                        .frame(width: 110, height: 110)
                        .overlay(
                            VStack(spacing: 2) {
                                Text("SIDE A")
                                    .font(.system(size: 9, weight: .bold))
                                    .kerning(1.5)
                                Text("33⅓")
                                    .font(.system(size: 13, weight: .semibold, design: .serif))
                            }
                            .foregroundStyle(Color(red: 0.15, green: 0.08, blue: 0.04))
                        )
                    Circle().fill(Color(red: 0.06, green: 0.05, blue: 0.05))
                        .frame(width: 10, height: 10)
                }
                .frame(width: 300, height: 300)
                .accessibilityHidden(true)

                Spacer()

                // Track identity: title serif (record-sleeve voice), artist quiet
                VStack(spacing: 3) {
                    Text("Midnight Drive")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    Text("The Nightowls · Night Shift, 1979")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer().frame(height: 26)

                // Needle-position scrubber: ticks, not a slider; played side lit
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<40, id: \.self) { i in
                            Capsule()
                                .fill(CGFloat(i) / 40.0 < progress ? amber : Color.white.opacity(0.15))
                                .frame(width: 4, height: i % 5 == 0 ? 16 : 9)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("1 minute 24 of 3 minutes 37")
                    HStack {
                        Text("1:24").font(.caption).monospacedDigit().foregroundStyle(.secondary)
                        Spacer()
                        Text("-2:13").font(.caption).monospacedDigit().foregroundStyle(.tertiary)
                    }
                }

                Spacer().frame(height: 22)

                // Play is the only loud thing in the room
                HStack(spacing: 44) {
                    Button {} label: {
                        Image(systemName: "backward.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    Button {} label: {
                        Image(systemName: "pause.fill")
                            .font(.title)
                            .frame(width: 72, height: 72)
                            .background(amber, in: Circle())
                            .foregroundStyle(Color(red: 0.15, green: 0.08, blue: 0.04))
                    }
                    Button {} label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
