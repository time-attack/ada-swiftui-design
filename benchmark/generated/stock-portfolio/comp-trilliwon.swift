// BRIEF: "Build a SwiftUI screen showing today's stock portfolio."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, stable ids, a11y)
import SwiftUI

@Observable final class PortfolioModel {
    var holdings: [Holding] = Holding.sample
    var totalValue = 48239.52
    var dayChange = 523.10
}

struct Holding: Identifiable {
    let id = UUID()
    let symbol: String, name: String
    let value: Double, changePct: Double
    static let sample = [
        Holding(symbol: "AAPL", name: "Apple", value: 14210.30, changePct: 1.2),
        Holding(symbol: "NVDA", name: "NVIDIA", value: 12894.10, changePct: 3.8),
        Holding(symbol: "MSFT", name: "Microsoft", value: 9412.55, changePct: 0.4),
        Holding(symbol: "TSLA", name: "Tesla", value: 6821.40, changePct: -2.4),
        Holding(symbol: "AMZN", name: "Amazon", value: 4901.17, changePct: -0.9),
    ]
}

@main
struct StocksApp: App {
    @State private var model = PortfolioModel()
    var body: some Scene { WindowGroup { PortfolioView(model: model) } }
}

struct PortfolioView: View {
    let model: PortfolioModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$48,239.52").font(.largeTitle.bold()).monospacedDigit()
                        Text("+$523.10 (+1.1%) today")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                }
                Section("Holdings") {
                    ForEach(model.holdings) { h in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(h.symbol).font(.headline)
                                Text(h.name).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("$\(h.value, specifier: "%.2f")")
                                    .font(.body).monospacedDigit()
                                Text("\(h.changePct >= 0 ? "+" : "")\(h.changePct, specifier: "%.1f")%")
                                    .font(.subheadline)
                                    .foregroundStyle(h.changePct >= 0 ? .green : .red)
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(h.name), \(h.value, specifier: "%.0f") dollars, \(h.changePct >= 0 ? "up" : "down") \(abs(h.changePct), specifier: "%.1f") percent")
                    }
                }
            }
            .navigationTitle("Portfolio")
        }
    }
}
