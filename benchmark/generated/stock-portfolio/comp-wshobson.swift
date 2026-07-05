// BRIEF: "Build a SwiftUI screen showing today's stock portfolio."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, cards, a11y)
import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene { WindowGroup { PortfolioView() } }
}

struct PortfolioView: View {
    let holdings = [("AAPL", "Apple", 14210.30, 1.2),
                    ("NVDA", "NVIDIA", 12894.10, 3.8),
                    ("MSFT", "Microsoft", 9412.55, 0.4),
                    ("TSLA", "Tesla", 6821.40, -2.4),
                    ("AMZN", "Amazon", 4901.17, -0.9)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                            .frame(width: 60, height: 60)
                            .background(.green.opacity(0.1), in: Circle())
                        Text("$48,239.52").font(.largeTitle.bold()).monospacedDigit()
                        Label("+$523.10 today", systemImage: "arrow.up.right")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)

                    ForEach(holdings, id: \.0) { h in
                        HStack(spacing: 16) {
                            Image(systemName: h.3 >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .font(.title3)
                                .foregroundStyle(h.3 >= 0 ? .green : .red)
                                .frame(width: 44, height: 44)
                                .background((h.3 >= 0 ? Color.green : .red).opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(h.0).font(.headline)
                                Text(h.1).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("$\(h.2, specifier: "%.2f")").font(.headline).monospacedDigit()
                                Text("\(h.3 >= 0 ? "+" : "")\(h.3, specifier: "%.1f")%")
                                    .font(.subheadline)
                                    .foregroundStyle(h.3 >= 0 ? .green : .red)
                            }
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Portfolio")
        }
    }
}
