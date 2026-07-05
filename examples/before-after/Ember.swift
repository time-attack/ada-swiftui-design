// EVAL APP 2 — "Ember", a recipe app. Screens: recipe detail, cooking mode.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: recipe → "do I want to cook this, and what do I need?"
//             cooking → "what do I do RIGHT NOW?" (hands dirty, phone on counter)
//   METAPHOR: an editorial cookbook page; then a sous-chef reading over your shoulder
//             (Mela's serif editorial + contextual dimming, Crouton's inline semantics).
//   TEMPERATURE: warm.
import SwiftUI

@main
struct EmberApp: App {
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
                if screen == 1 { A_Recipe() } else { A_Cooking() }
            } else {
                if screen == 1 { B_Recipe() } else { B_Cooking() }
            }
        }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Recipe: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Crispy Chicken Thighs 🍗").font(.title).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.orange, .red],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 180)
                    .overlay(Text("🍗").font(.system(size: 80)))
                    .shadow(radius: 5)

                HStack {
                    ForEach(0..<5) { _ in Text("⭐️") }
                    Text("(4.8)").foregroundColor(.gray)
                }

                HStack(spacing: 12) {
                    B_Chip(title: "Time", value: "45 min", color: .blue)
                    B_Chip(title: "Servings", value: "4", color: .green)
                    B_Chip(title: "Difficulty", value: "Easy", color: .orange)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients 🛒").font(.headline)
                    ForEach(["4 chicken thighs", "2 cloves garlic", "1 tbsp olive oil",
                             "Fresh thyme", "Salt and pepper"], id: \.self) { ing in
                        HStack {
                            Text("✅")
                            Text(ing)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6)).cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("Start Cooking! 👨‍🍳")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_Chip: View {
    let title: String, value: String
    let color: Color
    var body: some View {
        VStack {
            Text(title).font(.caption)
            Text(value).font(.headline).foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.15)).cornerRadius(12)
    }
}

struct B_Cooking: View {
    @State private var currentStep = 2
    let steps = [
        "Preheat the oven to 400°F",
        "Season the chicken thighs with salt and pepper",
        "Sear chicken skin-side down for 6 minutes",
        "Add garlic and thyme to the pan",
        "Transfer to oven and roast for 25 minutes",
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Cooking Mode 🍳").font(.largeTitle).bold()

            ProgressView(value: Double(currentStep), total: Double(steps.count))
                .padding(.horizontal)

            ScrollView {
                ForEach(steps.indices, id: \.self) { i in
                    HStack {
                        Text("\(i + 1)")
                            .frame(width: 32, height: 32)
                            .background(Color.blue).foregroundColor(.white)
                            .clipShape(Circle())
                        Text(steps[i])
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                }
            }

            HStack {
                Button("Previous") { currentStep = max(0, currentStep - 1) }
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.gray).foregroundColor(.white).cornerRadius(10)
                Button("Next Step") { currentStep = min(steps.count - 1, currentStep + 1) }
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

private let paprika = Color(red: 0.80, green: 0.33, blue: 0.20)
private let paper = Color(red: 0.99, green: 0.975, blue: 0.955)
private let inkText = Color(red: 0.15, green: 0.12, blue: 0.10)

struct A_Ingredient: Identifiable {
    let id = UUID()
    let qty: String, name: String
    static let list = [
        A_Ingredient(qty: "4", name: "chicken thighs, bone-in"),
        A_Ingredient(qty: "2 cloves", name: "garlic, crushed"),
        A_Ingredient(qty: "1 tbsp", name: "olive oil"),
        A_Ingredient(qty: "4 sprigs", name: "thyme"),
        A_Ingredient(qty: "to taste", name: "salt & black pepper"),
    ]
}

struct A_Recipe: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Editorial opening — cookbook page, not app header
                Text("Weeknight · Chicken")
                    .font(.caption.smallCaps().weight(.medium))
                    .kerning(1.4)
                    .foregroundStyle(paprika)

                Text("Crispy chicken thighs")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .padding(.top, 6)

                Text("Skin like glass, meat that falls off the bone. One pan, no fuss.")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                // Metadata as a quiet dotted row, not colored chips
                HStack(spacing: 8) {
                    metaItem("45 min")
                    dot
                    metaItem("Serves 4")
                    dot
                    metaItem("Easy")
                    dot
                    metaItem("One pan")
                }
                .padding(.top, 14)
                .accessibilityElement(children: .combine)

                Rectangle()
                    .fill(paprika.opacity(0.25))
                    .frame(height: 1)
                    .padding(.vertical, 22)

                Text("Ingredients")
                    .font(.caption.smallCaps())
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                // Quantities left column, tabular; names serif; hairline dividers
                VStack(spacing: 0) {
                    ForEach(A_Ingredient.list) { ing in
                        HStack(alignment: .firstTextBaseline, spacing: 14) {
                            Text(ing.qty)
                                .font(.subheadline.weight(.semibold))
                                .monospacedDigit()
                                .foregroundStyle(paprika)
                                .frame(width: 72, alignment: .trailing)
                            Text(ing.name)
                                .font(.system(.body, design: .serif))
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .accessibilityElement(children: .combine)
                        if ing.id != A_Ingredient.list.last?.id {
                            Divider().opacity(0.3).padding(.leading, 86)
                        }
                    }
                }
                .padding(.top, 4)

                Spacer().frame(height: 28)

                Button {} label: {
                    Label("Start cooking", systemImage: "flame.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(paprika, in: Capsule())
                .foregroundStyle(paper)

                Button("Add ingredients to grocery list") {}
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(24)
        }
        .background(paper.ignoresSafeArea())
        .foregroundStyle(inkText)
        .preferredColorScheme(.light)
    }

    private var dot: some View {
        Circle().fill(.tertiary).frame(width: 3, height: 3)
    }
    private func metaItem(_ s: String) -> some View {
        Text(s).font(.footnote.weight(.medium)).foregroundStyle(.secondary).monospacedDigit()
    }
}

// Cooking mode: current step at glance-from-counter scale, neighbors ghosted.
struct A_Step {
    enum Run {
        case plain(String), ingredient(String)
        case time(String, minutes: Int), amount(String)
    }
    let runs: [Run]
    var minutes: Int? {
        for case let .time(_, m) in runs { return m }
        return nil
    }
    static let all = [
        A_Step(runs: [.plain("Preheat the oven to "), .amount("400°F")]),
        A_Step(runs: [.plain("Season the "), .ingredient("chicken thighs"), .plain(" with "),
                      .ingredient("salt"), .plain(" and "), .ingredient("pepper")]),
        A_Step(runs: [.plain("Sear the chicken skin-side down for "), .time("6 min", minutes: 6)]),
        A_Step(runs: [.plain("Add "), .ingredient("garlic"), .plain(" and "),
                      .ingredient("thyme"), .plain(" to the pan")]),
        A_Step(runs: [.plain("Roast in the oven for "), .time("25 min", minutes: 25)]),
    ]
}

struct A_Cooking: View {
    @State private var current = 2
    private let steps = A_Step.all

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Text("Crispy chicken thighs")
                    .font(.caption.smallCaps()).kerning(1.0)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Step \(current + 1) of \(steps.count)")
                    .font(.caption.smallCaps()).kerning(1.0)
                    .foregroundStyle(.tertiary)
                    .monospacedDigit()
            }
            .padding(.horizontal, 24).padding(.top, 12)

            Spacer()

            if current > 0 {
                stepText(steps[current - 1], size: 22)
                    .foregroundStyle(.quaternary)
                    .lineLimit(2)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    .accessibilityHidden(true)
            }

            stepText(steps[current], size: 34, emphasized: true)
                .padding(.horizontal, 24)
                .animation(.spring(duration: 0.45), value: current)

            if let minutes = steps[current].minutes {
                Button {} label: {
                    Label("Start \(minutes)-minute timer", systemImage: "timer")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14).padding(.vertical, 9)
                }
                .background(paprika.opacity(0.14), in: Capsule())
                .foregroundStyle(paprika)
                .padding(.horizontal, 24).padding(.top, 18)
            }

            if current + 1 < steps.count {
                stepText(steps[current + 1], size: 22)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .accessibilityHidden(true)
            }

            Spacer()

            HStack(spacing: 6) {
                ForEach(steps.indices, id: \.self) { i in
                    Capsule()
                        .fill(i <= current ? AnyShapeStyle(paprika) : AnyShapeStyle(.quaternary))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 24)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(current + 1) of \(steps.count)")

            HStack {
                Button("Back") { withAnimation { current = max(0, current - 1) } }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    withAnimation { current = min(steps.count - 1, current + 1) }
                } label: {
                    Label("Done, next", systemImage: "arrow.right")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 22).padding(.vertical, 13)
                }
                .background(paprika, in: Capsule())
                .foregroundStyle(.white)
                .sensoryFeedback(.success, trigger: current)
            }
            .padding(24)
        }
        .background(paper.ignoresSafeArea())
        .foregroundStyle(inkText)
        .contentShape(Rectangle())
        .onTapGesture { withAnimation { current = min(steps.count - 1, current + 1) } }
        .preferredColorScheme(.light)
    }

    private func stepText(_ step: A_Step, size: CGFloat, emphasized: Bool = false) -> Text {
        step.runs.reduce(Text("")) { acc, run in
            switch run {
            case .plain(let s):
                return acc + Text(s)
                    .font(.system(size: size, weight: emphasized ? .semibold : .regular, design: .serif))
            case .ingredient(let s):
                return acc + Text(s)
                    .font(.system(size: size, weight: .bold, design: .serif))
                    .foregroundStyle(paprika)
            case .time(let s, _), .amount(let s):
                return acc + Text(s)
                    .font(.system(size: size, weight: .bold, design: .rounded))
                    .foregroundStyle(paprika)
            }
        }
    }
}
