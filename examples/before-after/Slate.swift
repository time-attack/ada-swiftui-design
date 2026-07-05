// EVAL APP 9 — "Slate", a to-do / notes app. Screen: today list.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: "what's the one thing I should do next?"
//   METAPHOR: a paper day-planner page — ink on cream, done items crossed out.
//   TEMPERATURE: warm-clinical (a tool, but a kind one).
import SwiftUI

@main
struct SlateApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        return Group { if after { A_Today() } else { B_Today() } }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Today: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("My Tasks ✅").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.green, .teal],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 110)
                    .overlay(VStack {
                        Text("Today's Progress 🎯").foregroundColor(.white)
                        Text("3 / 7 Done").font(.title).bold().foregroundColor(.white)
                        ProgressView(value: 0.43).tint(.white).padding(.horizontal, 40)
                    })
                    .shadow(radius: 5)

                HStack(spacing: 12) {
                    B_CatBox(name: "Work 💼", count: 3, color: .blue)
                    B_CatBox(name: "Home 🏠", count: 2, color: .orange)
                    B_CatBox(name: "Health 💪", count: 2, color: .pink)
                }

                VStack(alignment: .leading, spacing: 8) {
                    ForEach([("Finish the deck", "Work", false, Color.blue),
                             ("Email Rajni back", "Work", true, Color.blue),
                             ("Book dentist", "Health", false, Color.pink),
                             ("Buy groceries 🛒", "Home", true, Color.orange),
                             ("Gym session", "Health", true, Color.pink)], id: \.0) { t in
                        HStack {
                            Image(systemName: t.2 ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(t.3)
                            Text(t.0)
                            Spacer()
                            Text(t.1).font(.caption)
                                .padding(6).background(t.3.opacity(0.2)).cornerRadius(6)
                        }
                        .padding()
                        .background(Color(.systemGray6)).cornerRadius(12)
                    }
                }

                Button(action: {}) {
                    Text("+ Add New Task")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_CatBox: View {
    let name: String
    let count: Int
    let color: Color
    var body: some View {
        VStack {
            Text(name).font(.caption)
            Text("\(count)").font(.title2).bold().foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.15)).cornerRadius(12)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

private let slatePaper = Color(red: 0.99, green: 0.98, blue: 0.96)
private let slateInk = Color(red: 0.16, green: 0.15, blue: 0.13)
private let inkBlue = Color(red: 0.20, green: 0.35, blue: 0.70) // fountain-pen accent

struct A_Task: Identifiable {
    let id = UUID()
    let title: String
    let done: Bool
    var focus = false
    static let today = [
        A_Task(title: "Finish the investor deck", done: false, focus: true),
        A_Task(title: "Email Rajni about the invoice split", done: true),
        A_Task(title: "Book dentist for next week", done: false),
        A_Task(title: "Gym — pull day", done: true),
        A_Task(title: "Order AirTags for luggage", done: true),
    ]
    static let later = ["Renew passport photos", "Plan Osaka week itinerary"]
}

struct A_Today: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Saturday, July 5")
                    .font(.caption.smallCaps().weight(.medium))
                    .kerning(1.4)
                    .foregroundStyle(.secondary)

                Text("Today")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .padding(.top, 4)

                // Progress as a sentence, pointing at the next action
                Text("3 of 5 done — the deck is the big one left.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)

                Spacer().frame(height: 24)

                VStack(spacing: 0) {
                    ForEach(A_Task.today) { t in
                        HStack(alignment: .firstTextBaseline, spacing: 14) {
                            Image(systemName: t.done ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(t.done ? inkBlue.opacity(0.5) : (t.focus ? inkBlue : Color(.systemGray3)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(t.title)
                                    .font(t.focus ? .body.weight(.semibold) : .body)
                                    .strikethrough(t.done, color: .secondary)
                                    .foregroundStyle(t.done ? AnyShapeStyle(.tertiary) : AnyShapeStyle(slateInk))
                                if t.focus {
                                    Text("Today's focus")
                                        .font(.caption2.smallCaps().weight(.semibold))
                                        .kerning(0.8)
                                        .foregroundStyle(inkBlue)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 13)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(t.title), \(t.done ? "done" : t.focus ? "today's focus, not done" : "not done")")

                        if t.id != A_Task.today.last?.id {
                            Divider().opacity(0.35).padding(.leading, 38)
                        }
                    }
                }

                Spacer().frame(height: 28)

                // Later: present but ghosted — context recedes, never disappears
                Text("Later this week")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)

                VStack(spacing: 0) {
                    ForEach(A_Task.later, id: \.self) { title in
                        HStack(spacing: 14) {
                            Image(systemName: "circle.dotted")
                                .font(.title3)
                                .foregroundStyle(.quaternary)
                            Text(title)
                                .font(.body)
                                .foregroundStyle(.tertiary)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }
                }

                Spacer().frame(height: 20)

                Button {} label: {
                    Label("New task", systemImage: "plus")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(inkBlue, in: Capsule())
                .foregroundStyle(slatePaper)
            }
            .padding(24)
        }
        .background(slatePaper.ignoresSafeArea())
        .foregroundStyle(slateInk)
        .preferredColorScheme(.light)
    }
}
