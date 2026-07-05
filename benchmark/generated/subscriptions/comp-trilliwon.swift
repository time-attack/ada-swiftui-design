// BRIEF: "Build a SwiftUI screen showing my monthly subscriptions."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, stable ids, a11y)
import SwiftUI

@Observable final class SubsModel {
    var subs: [Sub] = Sub.sample
    var total: Double { subs.reduce(0) { $0 + $1.price } }
}

struct Sub: Identifiable {
    let id = UUID()
    let name: String, price: Double, renews: String
    static let sample = [
        Sub(name: "Netflix", price: 15.49, renews: "July 8"),
        Sub(name: "Spotify", price: 11.99, renews: "July 12"),
        Sub(name: "iCloud+", price: 2.99, renews: "July 15"),
        Sub(name: "Gym Membership", price: 45.00, renews: "July 21"),
        Sub(name: "YouTube Premium", price: 13.99, renews: "July 27"),
    ]
}

@main
struct SubsApp: App {
    @State private var model = SubsModel()
    var body: some Scene { WindowGroup { SubsView(model: model) } }
}

struct SubsView: View {
    let model: SubsModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(model.total, specifier: "%.2f") / month")
                            .font(.title2.bold())
                            .monospacedDigit()
                        Text("\(model.subs.count) active subscriptions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                }
                Section("Active") {
                    ForEach(model.subs) { s in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.name).font(.body)
                                Text("Renews \(s.renews)").font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$\(s.price, specifier: "%.2f")")
                                .font(.body)
                                .monospacedDigit()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(s.name), \(s.price, specifier: "%.2f") dollars, renews \(s.renews)")
                    }
                }
                Section {
                    Button {} label: {
                        Label("Add subscription", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Subscriptions")
        }
    }
}
