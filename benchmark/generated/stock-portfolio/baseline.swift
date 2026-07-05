// BRIEF: "Build a SwiftUI screen showing today's stock portfolio."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene { WindowGroup { PortfolioView() } }
}

struct PortfolioView: View {
    let stocks = [("AAPL", "+1.2%", true), ("TSLA", "-2.4%", false),
                  ("NVDA", "+3.8%", true), ("MSFT", "+0.4%", true), ("AMZN", "-0.9%", false)]
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("My Portfolio 📈").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.purple, .blue],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 150)
                    .overlay(VStack(spacing: 6) {
                        Text("Total Value").foregroundColor(.white.opacity(0.8))
                        Text("$48,239.52").font(.system(size: 36)).bold().foregroundColor(.white)
                        Text("+$523.10 today ✅").foregroundColor(.green)
                    })
                    .shadow(radius: 8)

                HStack(spacing: 12) {
                    box("Day Gain", "+1.1%", .green)
                    box("Total Gain", "+24%", .blue)
                    box("Cash", "$2.1k", .orange)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Holdings").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(stocks, id: \.0) { s in
                        HStack {
                            Text("💹"); Text(s.0).bold()
                            Spacer()
                            Text(s.1).foregroundColor(s.2 ? .green : .red).bold()
                        }
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("View Full Report")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
    func box(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
