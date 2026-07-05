// EVAL APP 5 — "Tide", a mood check-in + habits app. Screens: today, check-in.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: today → "how am I doing, gently?"  check-in → "name the feeling."
//   METAPHOR: How We Feel's color-as-emotional-coordinates + Gentler Streak's
//             encouraging voice. Color hue = valence, NOT decoration.
//   TEMPERATURE: warm.
import SwiftUI

@main
struct TideApp: App {
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
                if screen == 1 { A_Today() } else { A_CheckIn() }
            } else {
                if screen == 1 { B_Today() } else { B_CheckIn() }
            }
        }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Today: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("How are you feeling? 😊").font(.title).bold()

                HStack(spacing: 12) {
                    ForEach(["😢", "😕", "😐", "🙂", "😄"], id: \.self) { e in
                        Button(action: {}) {
                            Text(e).font(.system(size: 40))
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.purple, .pink],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 100)
                    .overlay(VStack {
                        Text("🔥 Current Streak").foregroundColor(.white)
                        Text("12 Days!").font(.title).bold().foregroundColor(.white)
                    })
                    .shadow(radius: 5)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Habits ✅").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach([("Drink water 💧", true, Color.blue),
                             ("Exercise 💪", true, Color.green),
                             ("Meditate 🧘", false, Color.purple),
                             ("Read 📚", false, Color.orange)], id: \.0) { h in
                        HStack {
                            Text(h.0)
                            Spacer()
                            Image(systemName: h.1 ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(h.2)
                        }
                        .padding()
                        .background(h.2.opacity(0.12)).cornerRadius(12)
                    }
                }

                Button(action: {}) {
                    Text("Log Your Mood")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_CheckIn: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Mood Check-In 📝").font(.largeTitle).bold()

            Text("Rate your mood from 1-10").foregroundColor(.gray)

            HStack {
                ForEach(1...5, id: \.self) { i in
                    Button(action: {}) {
                        Text("\(i)")
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(Double(i) * 0.2))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(height: 120)
                .overlay(Text("Add a note... ✏️").foregroundColor(.gray))
                .padding(.horizontal)

            HStack {
                Button("Cancel") {}
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.gray).foregroundColor(.white).cornerRadius(10)
                Button("Save Mood") {}
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

// Morning canvas: soft dawn peach → cream. The time of day sets the temperature.
private var dawnCanvas: LinearGradient {
    LinearGradient(stops: [
        .init(color: Color(red: 1.00, green: 0.93, blue: 0.86), location: 0),
        .init(color: Color(red: 0.99, green: 0.97, blue: 0.94), location: 0.5),
        .init(color: Color(red: 0.98, green: 0.98, blue: 0.96), location: 1),
    ], startPoint: .top, endPoint: .bottom)
}
private let tideInk = Color(red: 0.22, green: 0.16, blue: 0.12)

// Feelings: hue encodes valence+energy (How We Feel's quadrant logic)
struct A_Feeling: Identifiable {
    let id = UUID()
    let word: String
    let hue: Color
    static let grid = [
        A_Feeling(word: "Jittery", hue: Color(red: 0.92, green: 0.45, blue: 0.35)),   // high energy, unpleasant
        A_Feeling(word: "Excited", hue: Color(red: 0.98, green: 0.72, blue: 0.30)),   // high energy, pleasant
        A_Feeling(word: "Drained", hue: Color(red: 0.50, green: 0.58, blue: 0.80)),   // low energy, unpleasant
        A_Feeling(word: "Calm", hue: Color(red: 0.45, green: 0.75, blue: 0.60)),      // low energy, pleasant
        A_Feeling(word: "Tense", hue: Color(red: 0.88, green: 0.55, blue: 0.45)),
        A_Feeling(word: "Focused", hue: Color(red: 0.95, green: 0.80, blue: 0.45)),
        A_Feeling(word: "Lonely", hue: Color(red: 0.60, green: 0.65, blue: 0.85)),
        A_Feeling(word: "Content", hue: Color(red: 0.55, green: 0.80, blue: 0.65)),
    ]
}

// THE CHARACTER — every feeling gets a hand-drawn face. Expression is geometry:
// zigzag mouth = jittery, filled open smile = excited, heavy-lidded = drained,
// closed ∪-eyes = calm. Drawn in Canvas; no emoji glyphs, no assets.
struct A_Face: View {
    let mood: String
    let ink: Color

    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let stroke = StrokeStyle(lineWidth: max(1.5, w * 0.06), lineCap: .round)
            let eyeY = w * 0.38
            let mouthY = w * 0.66
            let lx = w * 0.32, rx = w * 0.68

            func dot(_ x: CGFloat) {
                let r = w * 0.055
                ctx.fill(Path(ellipseIn: CGRect(x: x - r, y: eyeY - r, width: r * 2, height: r * 2)),
                         with: .color(ink))
            }
            func curve(_ x: CGFloat, lift: CGFloat) {
                var p = Path()
                p.move(to: CGPoint(x: x - w * 0.09, y: eyeY))
                p.addQuadCurve(to: CGPoint(x: x + w * 0.09, y: eyeY),
                               control: CGPoint(x: x, y: eyeY + lift))
                ctx.stroke(p, with: .color(ink), style: stroke)
            }
            func flat(_ x: CGFloat) {
                var p = Path()
                p.move(to: CGPoint(x: x - w * 0.09, y: eyeY))
                p.addLine(to: CGPoint(x: x + w * 0.09, y: eyeY))
                ctx.stroke(p, with: .color(ink), style: stroke)
            }

            switch mood {
            case "Calm", "Content": curve(lx, lift: -w * 0.10); curve(rx, lift: -w * 0.10)
            case "Drained", "Lonely": flat(lx); flat(rx)
            default: dot(lx); dot(rx)
            }

            var m = Path()
            switch mood {
            case "Jittery":
                m.move(to: CGPoint(x: w * 0.30, y: mouthY))
                m.addLine(to: CGPoint(x: w * 0.40, y: mouthY - w * 0.05))
                m.addLine(to: CGPoint(x: w * 0.50, y: mouthY + w * 0.05))
                m.addLine(to: CGPoint(x: w * 0.60, y: mouthY - w * 0.05))
                m.addLine(to: CGPoint(x: w * 0.70, y: mouthY))
                ctx.stroke(m, with: .color(ink), style: stroke)
            case "Excited":
                m.move(to: CGPoint(x: w * 0.32, y: mouthY - w * 0.03))
                m.addQuadCurve(to: CGPoint(x: w * 0.68, y: mouthY - w * 0.03),
                               control: CGPoint(x: w * 0.5, y: mouthY + w * 0.26))
                m.closeSubpath()
                ctx.fill(m, with: .color(ink))
            case "Tense":
                m.move(to: CGPoint(x: w * 0.34, y: mouthY))
                m.addLine(to: CGPoint(x: w * 0.66, y: mouthY))
                ctx.stroke(m, with: .color(ink), style: stroke)
            case "Focused":
                m.move(to: CGPoint(x: w * 0.40, y: mouthY))
                m.addLine(to: CGPoint(x: w * 0.60, y: mouthY))
                ctx.stroke(m, with: .color(ink), style: stroke)
            case "Drained", "Lonely":
                m.move(to: CGPoint(x: w * 0.36, y: mouthY + w * 0.04))
                m.addQuadCurve(to: CGPoint(x: w * 0.64, y: mouthY + w * 0.04),
                               control: CGPoint(x: w * 0.5, y: mouthY - w * 0.08))
                ctx.stroke(m, with: .color(ink), style: stroke)
            default:
                m.move(to: CGPoint(x: w * 0.34, y: mouthY - w * 0.02))
                m.addQuadCurve(to: CGPoint(x: w * 0.66, y: mouthY - w * 0.02),
                               control: CGPoint(x: w * 0.5, y: mouthY + w * 0.10))
                ctx.stroke(m, with: .color(ink), style: stroke)
            }
        }
        .accessibilityHidden(true)
    }
}

struct A_Habit: Identifiable {
    let id = UUID()
    let name: String, symbol: String
    let done: Bool
    static let all = [
        A_Habit(name: "Morning walk", symbol: "figure.walk", done: true),
        A_Habit(name: "10 minutes of reading", symbol: "book", done: true),
        A_Habit(name: "Meditate", symbol: "leaf", done: false),
        A_Habit(name: "In bed by 11", symbol: "moon", done: false),
    ]
}

struct A_Today: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Saturday morning")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                // Hero is a question in a human voice, serif = journal warmth
                Text("How's your energy today?")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .padding(.top, 6)

                // Feeling grid: word + hue, 2 rows. Color = valence, labeled always.
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4),
                          spacing: 10) {
                    ForEach(A_Feeling.grid) { f in
                        Button {} label: {
                            VStack(spacing: 6) {
                                A_Face(mood: f.word, ink: tideInk.opacity(0.85))
                                    .frame(width: 34, height: 34)
                                Text(f.word)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(tideInk)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .background(f.hue.opacity(0.28), in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(f.hue.opacity(0.5), lineWidth: 1))
                    }
                }
                .padding(.top, 18)

                Spacer().frame(height: 30)

                // Streak, gently. No fire emoji, no pressure.
                Text("You've checked in 12 mornings in a row. No rush today.")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                Spacer().frame(height: 26)

                Text("Today")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)

                VStack(spacing: 0) {
                    ForEach(A_Habit.all) { h in
                        HStack(spacing: 12) {
                            Image(systemName: h.symbol)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(h.done ? .secondary : Color(red: 0.85, green: 0.50, blue: 0.30))
                                .frame(width: 26)
                            Text(h.name)
                                .font(.body)
                                .strikethrough(h.done, color: .secondary)
                                .foregroundStyle(h.done ? AnyShapeStyle(.tertiary) : AnyShapeStyle(tideInk))
                            Spacer()
                            Image(systemName: h.done ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(h.done ? Color(red: 0.45, green: 0.75, blue: 0.60) : Color(.systemGray4))
                        }
                        .padding(.vertical, 12)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(h.name), \(h.done ? "done" : "not yet")")

                        if h.id != A_Habit.all.last?.id {
                            Divider().opacity(0.3).padding(.leading, 38)
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(dawnCanvas.ignoresSafeArea())
        .foregroundStyle(tideInk)
        .preferredColorScheme(.light)
    }
}

// Check-in: the chosen feeling's hue gently floods the canvas — color = the data.
struct A_CheckIn: View {
    private let feeling = A_Feeling.grid[0] // "Jittery"
    @State private var intensity = 3

    var body: some View {
        ZStack {
            LinearGradient(stops: [
                .init(color: feeling.hue.opacity(0.30), location: 0),
                .init(color: Color(red: 0.99, green: 0.97, blue: 0.94), location: 0.7),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("This morning, you're feeling")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                Text("Jittery")
                    .font(.system(size: 56, weight: .bold, design: .serif))
                    .foregroundStyle(feeling.hue)
                    .padding(.top, 4)

                Text("High energy, a little unsettled. That's okay — it happens.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)

                Spacer()

                // The feeling, embodied: big drawn face with energy ticks radiating —
                // the "jitter" is drawn, not just named.
                ZStack {
                    Canvas { ctx, size in
                        let c = CGPoint(x: size.width / 2, y: size.height / 2)
                        let r1 = size.width * 0.36
                        for i in 0..<10 {
                            let ang = Double(i) / 10.0 * 2 * .pi - .pi / 2
                            let jag = CGFloat(i % 2 == 0 ? 14 : 7)
                            var p = Path()
                            p.move(to: CGPoint(x: c.x + cos(ang) * r1,
                                               y: c.y + sin(ang) * r1))
                            p.addLine(to: CGPoint(x: c.x + cos(ang) * (r1 + jag),
                                                  y: c.y + sin(ang) * (r1 + jag)))
                            ctx.stroke(p, with: .color(.init(red: 0.92, green: 0.45, blue: 0.35)),
                                       style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        }
                    }
                    Circle()
                        .fill(feeling.hue.opacity(0.22))
                        .padding(14)
                    Circle()
                        .stroke(feeling.hue.opacity(0.55), lineWidth: 1.5)
                        .padding(14)
                    A_Face(mood: "Jittery", ink: tideInk.opacity(0.9))
                        .padding(38)
                }
                .frame(width: 186, height: 186)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)

                Spacer()

                // Intensity as physical ticks, not a 1-10 number row
                VStack(alignment: .leading, spacing: 12) {
                    Text("How strong is it?")
                        .font(.caption.smallCaps())
                        .kerning(1.0)
                        .foregroundStyle(.tertiary)
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { i in
                            Capsule()
                                .fill(i <= intensity ? AnyShapeStyle(feeling.hue) : AnyShapeStyle(.quaternary))
                                .frame(height: 12 + CGFloat(i) * 5)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    withAnimation(.spring(duration: 0.3)) { intensity = i }
                                }
                        }
                    }
                    .sensoryFeedback(.impact(weight: .light), trigger: intensity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Intensity \(intensity) of 5")
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment: intensity = min(5, intensity + 1)
                        case .decrement: intensity = max(1, intensity - 1)
                        @unknown default: break
                        }
                    }
                    HStack {
                        Text("barely there").font(.caption2).foregroundStyle(.tertiary)
                        Spacer()
                        Text("can't ignore it").font(.caption2).foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                Button {} label: {
                    Text("Log this feeling")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(feeling.hue, in: Capsule())
                .foregroundStyle(.white)

                Button("Not quite — pick another word") {}
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(24)
        }
        .foregroundStyle(tideInk)
        .preferredColorScheme(.light)
    }
}
