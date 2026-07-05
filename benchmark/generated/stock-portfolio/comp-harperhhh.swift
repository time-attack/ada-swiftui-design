// BRIEF: "Build a SwiftUI screen showing today's stock portfolio."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji chips)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)

@main
struct StocksApp: App {
    var body: some Scene { WindowGroup { PortfolioView() } }
}

struct PortfolioView: View {
    let holdings = [("AAPL", "Apple", "$14,210", "+1.2%", true),
                    ("NVDA", "NVIDIA", "$12,894", "+3.8%", true),
                    ("MSFT", "Microsoft", "$9,412", "+0.4%", true),
                    ("TSLA", "Tesla", "$6,821", "-2.4%", false),
                    ("AMZN", "Amazon", "$4,901", "-0.9%", false)]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Portfolio")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Total value")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Text("$48,239.52")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("＋$523.10 today")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(hSage.opacity(0.5))
                        .clipShape(Capsule())
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                Text("Holdings")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    ForEach(holdings, id: \.0) { h in
                        HStack(spacing: 12) {
                            Text(String(h.0.prefix(1)))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .frame(width: 40, height: 40)
                                .background((h.4 ? hSky : hPeach).opacity(0.4))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(h.0).font(.system(size: 16, weight: .bold, design: .rounded))
                                Text(h.1).font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(hSecondaryText)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(h.2).font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .monospacedDigit()
                                Text(h.3).font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundStyle(hSecondaryText)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(hBackground)
        .foregroundStyle(hPrimaryText)
    }
}
