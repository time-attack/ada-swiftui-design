// EVAL APP 3 — "Ledger", a budget app. Screens: month overview, category detail.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: overview → "can I still spend?"  category → "where did Food money go?"
//   METAPHOR: a cockpit fuel gauge at night (Copilot Money's instrument-panel dark).
//   TEMPERATURE: clinical, but on your side.
import SwiftUI

@main
struct LedgerApp: App {
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
                if screen == 1 { A_Overview() } else { A_CategoryDetail() }
            } else {
                if screen == 1 { B_Overview() } else { B_CategoryDetail() }
            }
        }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Overview: View {
    let txns = [("Whole Foods", "🛒", "-$84.20"), ("Uber", "🚗", "-$23.10"), ("Netflix", "🎬", "-$15.49")]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Hi Sina! 💰 Here's your budget").font(.title2).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.purple, .blue],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 170)
                    .overlay(VStack(spacing: 8) {
                        Text("Total Balance").foregroundColor(.white.opacity(0.8))
                        Text("$4,523.10").font(.system(size: 40)).bold().foregroundColor(.white)
                        Text("**** 1002").foregroundColor(.white.opacity(0.6))
                    })
                    .shadow(radius: 8)

                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 12) {
                    B_StatBox(title: "Income", value: "$6,200", color: .green)
                    B_StatBox(title: "Spent", value: "$3,352", color: .red)
                    B_StatBox(title: "Saved", value: "$1,148", color: .blue)
                    B_StatBox(title: "Bills", value: "$1,700", color: .orange)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Transactions").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(txns, id: \.0) { t in
                        HStack {
                            Text(t.1)
                            VStack(alignment: .leading) {
                                Text(t.0)
                                Text("Today").font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Text(t.2).bold()
                        }
                        .padding()
                        .background(Color(.systemGray6)).cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("View All Transactions")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_StatBox: View {
    let title: String, value: String
    let color: Color
    var body: some View {
        VStack {
            Text(title).font(.caption)
            Text(value).font(.title3).bold().foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.15)).cornerRadius(12)
    }
}

struct B_CategoryDetail: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Food & Drink 🍔").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.orange, .yellow],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 120)
                    .overlay(VStack {
                        Text("Spent This Month").foregroundColor(.white)
                        Text("$820 / $1,000").font(.title).bold().foregroundColor(.white)
                    })
                    .shadow(radius: 5)

                ProgressView(value: 0.82)
                    .tint(.orange)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    B_StatBox(title: "Transactions", value: "23", color: .blue)
                    B_StatBox(title: "Avg/Day", value: "$27", color: .green)
                    B_StatBox(title: "vs June", value: "+12%", color: .red)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Transactions").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach([("Whole Foods", "🛒", "$84.20"), ("Chipotle", "🌯", "$14.85"),
                             ("Starbucks", "☕️", "$7.25"), ("Trader Joe's", "🛒", "$56.40")], id: \.0) { t in
                        HStack {
                            Text(t.1)
                            Text(t.0)
                            Spacer()
                            Text(t.2).bold()
                        }
                        .padding()
                        .background(Color(.systemGray6)).cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

private let panel = Color(red: 0.05, green: 0.05, blue: 0.07)
private let onTrack = Color(red: 0.30, green: 0.85, blue: 0.55)
private let foodHue = Color(red: 1.00, green: 0.60, blue: 0.30)

struct A_Category: Identifiable {
    let id = UUID()
    let name: String, symbol: String
    let spent: Int, budget: Int
    let hue: Color
    var fraction: Double { Double(spent) / Double(budget) }
    var over: Bool { spent > budget }
    static let all = [
        A_Category(name: "Food & Drink", symbol: "fork.knife", spent: 820, budget: 1000, hue: foodHue),
        A_Category(name: "Transport", symbol: "car.fill", spent: 340, budget: 400,
                   hue: Color(red: 0.35, green: 0.65, blue: 1.00)),
        A_Category(name: "Shopping", symbol: "bag.fill", spent: 480, budget: 350,
                   hue: Color(red: 0.85, green: 0.45, blue: 0.95)),
        A_Category(name: "Bills", symbol: "bolt.fill", spent: 1700, budget: 1700,
                   hue: Color(red: 0.95, green: 0.80, blue: 0.30)),
        A_Category(name: "Fun", symbol: "gamecontroller.fill", spent: 260, budget: 500,
                   hue: Color(red: 0.40, green: 0.90, blue: 0.75)),
    ]
}

struct A_Overview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("July")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                (Text("$2,847")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                 + Text(".60")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary))
                    .monospacedDigit()
                    .foregroundStyle(onTrack)
                    .accessibilityLabel("2,847 dollars 60 cents left to spend in July")

                Text("left to spend · 12 days to go")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                Label("Spending $31/day slower than June", systemImage: "arrow.down.right")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(onTrack)
                    .padding(.top, 10)

                Spacer().frame(height: 34)

                VStack(spacing: 0) {
                    ForEach(A_Category.all) { c in
                        HStack(spacing: 12) {
                            Image(systemName: c.symbol)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(c.hue)
                                .frame(width: 30, height: 30)
                                .background(c.hue.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(c.name).font(.subheadline.weight(.medium))
                                    if c.over {
                                        Text("over")
                                            .font(.caption2.smallCaps().weight(.semibold))
                                            .foregroundStyle(.orange)
                                    }
                                    Spacer()
                                    (Text("$\(c.spent)").foregroundStyle(.primary)
                                     + Text(" / $\(c.budget)").foregroundStyle(.tertiary))
                                        .font(.subheadline)
                                        .monospacedDigit()
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(.quaternary)
                                        Capsule()
                                            .fill(c.over ? .orange : c.hue)
                                            .frame(width: geo.size.width * min(c.fraction, 1))
                                    }
                                }
                                .frame(height: 5)
                            }
                        }
                        .padding(.vertical, 11)
                        .accessibilityElement(children: .combine)

                        if c.id != A_Category.all.last?.id {
                            Divider().opacity(0.35).padding(.leading, 42)
                        }
                    }
                }

                Button("All transactions") {}
                    .font(.subheadline.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(24)
        }
        .background(panel.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}

// Category detail: one identity hue carried through; days as capsules; txns grouped.
struct A_Txn: Identifiable {
    let id = UUID()
    let merchant: String, day: String, amount: String
    static let all = [
        A_Txn(merchant: "Whole Foods", day: "Today", amount: "$84.20"),
        A_Txn(merchant: "Chipotle", day: "Today", amount: "$14.85"),
        A_Txn(merchant: "Starbucks", day: "Yesterday", amount: "$7.25"),
        A_Txn(merchant: "Trader Joe's", day: "Yesterday", amount: "$56.40"),
        A_Txn(merchant: "Sushi Gen", day: "Wednesday", amount: "$62.10"),
    ]
}

struct A_CategoryDetail: View {
    private let daily: [Double] = [22, 41, 0, 35, 88, 14, 27, 0, 51, 30, 62, 84]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Image(systemName: "fork.knife")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(foodHue)
                        .frame(width: 30, height: 30)
                        .background(foodHue.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                    Text("Food & Drink · July")
                        .font(.subheadline.smallCaps().weight(.medium))
                        .kerning(1.2)
                        .foregroundStyle(.secondary)
                }

                (Text("$820")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                 + Text(" of $1,000")
                    .font(.system(size: 26, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary))
                    .monospacedDigit()
                    .padding(.top, 10)
                    .accessibilityLabel("820 of 1,000 dollars spent on food and drink")

                Text("On pace to finish the month $40 under budget.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer().frame(height: 30)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Day by day")
                        .font(.caption.smallCaps())
                        .kerning(1.0)
                        .foregroundStyle(.tertiary)
                    HStack(alignment: .bottom, spacing: 5) {
                        ForEach(daily.indices, id: \.self) { i in
                            Capsule()
                                .fill(i == daily.count - 1 ? AnyShapeStyle(foodHue) : AnyShapeStyle(.quaternary))
                                .frame(height: max(4, daily[i] * 0.9))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 84)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Daily food spending this month, highest 88 dollars on July 5, today 84 dollars")
                }

                Spacer().frame(height: 30)

                Text("Transactions")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)

                VStack(spacing: 0) {
                    ForEach(A_Txn.all) { t in
                        HStack(spacing: 12) {
                            Text(String(t.merchant.prefix(1)))
                                .font(.subheadline.weight(.semibold))
                                .frame(width: 30, height: 30)
                                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 1) {
                                Text(t.merchant).font(.subheadline.weight(.medium))
                                Text(t.day).font(.caption).foregroundStyle(.tertiary)
                            }
                            Spacer()
                            Text(t.amount)
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 10)
                        .accessibilityElement(children: .combine)
                        if t.id != A_Txn.all.last?.id {
                            Divider().opacity(0.35).padding(.leading, 42)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .padding(24)
        }
        .background(panel.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
