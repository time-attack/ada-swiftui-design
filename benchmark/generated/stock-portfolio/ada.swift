// BRIEF: "Build a SwiftUI screen showing today's stock portfolio."
// VARIANT: ada — skill applied.
// QUESTION: "am I up or down today, and what's driving it?"
// METAPHOR: a trading-desk instrument panel after hours.
// TEMPERATURE: clinical.  STAGE: instrument (the day's P/L curve IS the scene).
import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene { WindowGroup { PortfolioView() } }
}

struct A_Holding: Identifiable {
    let id = UUID()
    let symbol: String, value: Double, changePct: Double
    let spark: [Double]
    static let all = [
        A_Holding(symbol: "NVDA", value: 12894, changePct: 3.8, spark: [2, 3, 2.8, 4, 5, 6, 6.4]),
        A_Holding(symbol: "AAPL", value: 14210, changePct: 1.2, spark: [3, 3.2, 2.9, 3.4, 3.8, 4, 4.1]),
        A_Holding(symbol: "MSFT", value: 9413, changePct: 0.4, spark: [3, 3.1, 3, 3.2, 3.1, 3.3, 3.2]),
        A_Holding(symbol: "AMZN", value: 4901, changePct: -0.9, spark: [4, 3.8, 3.9, 3.6, 3.5, 3.4, 3.3]),
        A_Holding(symbol: "TSLA", value: 6821, changePct: -2.4, spark: [5, 4.6, 4.8, 4.2, 3.9, 3.6, 3.4]),
    ]
}

// Today's P/L curve as a filled terrain; a func inside a ViewBuilder closure is
// illegal, so the chart owns its own geometry helpers.
struct DayCurveChart: View {
    let day: [Double]
    let up: Color
    private let maxV = 2.6, minV = -0.4

    private func pt(_ i: Int, _ w: CGFloat, _ h: CGFloat) -> CGPoint {
        CGPoint(x: w * CGFloat(i) / CGFloat(day.count - 1),
                y: h * CGFloat(1 - (day[i] - minV) / (maxV - minV)))
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let zeroY = h * CGFloat(1 - (0 - minV) / (maxV - minV))
            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: 0, y: zeroY))
                    for i in day.indices { p.addLine(to: pt(i, w, h)) }
                    p.addLine(to: CGPoint(x: w, y: zeroY))
                    p.closeSubpath()
                }
                .fill(LinearGradient(colors: [up.opacity(0.30), up.opacity(0.02)],
                                     startPoint: .top, endPoint: .bottom))
                Path { p in
                    p.move(to: pt(0, w, h))
                    for i in day.indices { p.addLine(to: pt(i, w, h)) }
                }
                .stroke(up, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .shadow(color: up.opacity(0.8), radius: 5)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: zeroY))
                    p.addLine(to: CGPoint(x: w, y: zeroY))
                }
                .stroke(.white.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [3, 4]))
                Circle().fill(.white).frame(width: 8, height: 8)
                    .shadow(color: up, radius: 5)
                    .position(pt(day.count - 1, w, h))
            }
        }
    }
}

struct PortfolioView: View {
    private let up = Color(red: 0.30, green: 0.85, blue: 0.55)
    private let down = Color(red: 1.00, green: 0.45, blue: 0.40)
    // today's portfolio curve, market open → now
    private let day: [Double] = [0, 0.4, 0.2, 0.9, 0.7, 1.3, 1.1, 1.6, 1.4, 1.9, 2.2, 2.0, 2.4]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Portfolio · market open")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                (Text("+$523")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                 + Text(".10")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary))
                    .monospacedDigit()
                    .foregroundStyle(up)
                    .padding(.top, 8)
                    .accessibilityLabel("Up 523 dollars 10 cents today")

                Text("$48,239.52 total · NVDA is doing the lifting.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                // THE SCENE: today's P/L as terrain — filled area chart, zero line etched
                DayCurveChart(day: day, up: up)
                    .frame(height: 150)
                    .padding(.top, 18)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Today's gain curve, up 1.1 percent since open, small dip at 11 AM")

                HStack {
                    Text("9:30").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                    Spacer()
                    Text("now").font(.caption2).foregroundStyle(up)
                }
                .padding(.top, 4)

                Spacer().frame(height: 26)

                Text("Holdings")
                    .font(.caption.smallCaps())
                    .kerning(1.0)
                    .foregroundStyle(.tertiary)

                // Rows are instruments: every holding carries its own day-spark
                VStack(spacing: 0) {
                    ForEach(A_Holding.all) { hld in
                        let hue = hld.changePct >= 0 ? up : down
                        HStack(spacing: 12) {
                            Text(hld.symbol)
                                .font(.system(.subheadline, design: .monospaced).weight(.bold))
                                .frame(width: 62, alignment: .leading)
                            // spark: the holding's actual day shape
                            GeometryReader { geo in
                                let w = geo.size.width, h = geo.size.height
                                let mx = hld.spark.max() ?? 1, mn = hld.spark.min() ?? 0
                                Path { p in
                                    for (i, v) in hld.spark.enumerated() {
                                        let x = w * CGFloat(i) / CGFloat(hld.spark.count - 1)
                                        let y = h * CGFloat(1 - (v - mn) / max(0.001, mx - mn))
                                        if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                                        else { p.addLine(to: CGPoint(x: x, y: y)) }
                                    }
                                }
                                .stroke(hue.opacity(0.9), lineWidth: 1.8)
                            }
                            .frame(width: 64, height: 22)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 1) {
                                Text("$\(Int(hld.value).formatted())")
                                    .font(.subheadline.weight(.semibold))
                                    .monospacedDigit()
                                Text("\(hld.changePct >= 0 ? "+" : "")\(hld.changePct, specifier: "%.1f")%")
                                    .font(.caption.weight(.semibold))
                                    .monospacedDigit()
                                    .foregroundStyle(hue)
                            }
                        }
                        .padding(.vertical, 12)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(hld.symbol), \(Int(hld.value)) dollars, \(hld.changePct >= 0 ? "up" : "down") \(abs(hld.changePct), specifier: "%.1f") percent")

                        if hld.id != A_Holding.all.last?.id {
                            Divider().opacity(0.35).padding(.leading, 74)
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(Color(red: 0.05, green: 0.05, blue: 0.07).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
