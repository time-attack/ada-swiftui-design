// BRIEF: "Build a SwiftUI screen showing my monthly subscriptions."
// VARIANT: ada — skill applied.
// QUESTION: "what's my monthly burn, and what's about to charge me?"
// METAPHOR: a utility ledger + a 30-day radar strip — renewals are events in time,
//           not rows in a table.
// TEMPERATURE: clinical, on your side.  STAGE: instrument (the month ahead).
import SwiftUI

@main
struct SubsApp: App {
    var body: some Scene { WindowGroup { SubsView() } }
}

struct A_Sub: Identifiable {
    let id = UUID()
    let name: String, symbol: String, price: Double
    let renewDay: Int          // days from today
    let hue: Color
    static let all = [
        A_Sub(name: "Netflix", symbol: "tv", price: 15.49, renewDay: 3,
              hue: Color(red: 0.95, green: 0.35, blue: 0.35)),
        A_Sub(name: "Spotify", symbol: "music.note", price: 11.99, renewDay: 7,
              hue: Color(red: 0.35, green: 0.85, blue: 0.55)),
        A_Sub(name: "iCloud+", symbol: "icloud.fill", price: 2.99, renewDay: 10,
              hue: Color(red: 0.40, green: 0.70, blue: 1.00)),
        A_Sub(name: "Gym", symbol: "dumbbell.fill", price: 45.00, renewDay: 16,
              hue: Color(red: 1.00, green: 0.72, blue: 0.25)),
        A_Sub(name: "YouTube Premium", symbol: "play.rectangle.fill", price: 13.99, renewDay: 22,
              hue: Color(red: 0.90, green: 0.45, blue: 0.60)),
    ]
}

struct SubsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Subscriptions · July")
                    .font(.subheadline.smallCaps().weight(.medium))
                    .kerning(1.2)
                    .foregroundStyle(.secondary)

                (Text("$89")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                 + Text(".46")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                 + Text(" /mo")
                    .font(.system(size: 26, weight: .medium, design: .rounded))
                    .foregroundStyle(.tertiary))
                    .monospacedDigit()
                    .padding(.top, 8)
                    .accessibilityLabel("89 dollars 46 cents per month")

                Text("Netflix charges in 3 days — everything else is quiet this week.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                Spacer().frame(height: 30)

                // THE INSTRUMENT: the next 30 days as a strip; each renewal is a
                // dot at its REAL day, in its identity hue, sized by price.
                VStack(alignment: .leading, spacing: 10) {
                    Text("Next 30 days")
                        .font(.caption.smallCaps())
                        .kerning(1.0)
                        .foregroundStyle(.tertiary)
                    GeometryReader { geo in
                        let w = geo.size.width
                        ZStack(alignment: .leading) {
                            // week ticks
                            ForEach([0, 7, 14, 21, 28], id: \.self) { d in
                                Rectangle().fill(.white.opacity(0.12))
                                    .frame(width: 1, height: 26)
                                    .offset(x: w * CGFloat(d) / 30.0)
                            }
                            Capsule().fill(.white.opacity(0.10)).frame(height: 3)
                            ForEach(A_Sub.all) { s in
                                let sz: CGFloat = s.price > 20 ? 16 : s.price > 10 ? 12 : 9
                                Circle().fill(s.hue)
                                    .frame(width: sz, height: sz)
                                    .shadow(color: s.hue.opacity(0.8), radius: 4)
                                    .offset(x: w * CGFloat(s.renewDay) / 30.0 - sz / 2)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 34)
                    HStack {
                        Text("today").font(.caption2).foregroundStyle(.tertiary)
                        Spacer()
                        Text("Aug 4").font(.caption2).monospacedDigit().foregroundStyle(.tertiary)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Renewal timeline: Netflix in 3 days, Spotify in 7, iCloud in 10, Gym in 16, YouTube in 22")

                Spacer().frame(height: 26)

                // Ledger rows: identity hue on the chip only; phase-appropriate fact
                VStack(spacing: 0) {
                    ForEach(A_Sub.all) { s in
                        HStack(spacing: 12) {
                            Image(systemName: s.symbol)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(s.hue)
                                .frame(width: 30, height: 30)
                                .background(s.hue.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 1) {
                                Text(s.name).font(.subheadline.weight(.medium))
                                Text(s.renewDay <= 3 ? "Charges in \(s.renewDay) days"
                                     : "Renews July \(4 + s.renewDay)")
                                    .font(.caption)
                                    .monospacedDigit()
                                    .foregroundStyle(s.renewDay <= 3 ? AnyShapeStyle(s.hue)
                                                     : AnyShapeStyle(.tertiary))
                            }
                            Spacer()
                            Text("$\(s.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 11)
                        .accessibilityElement(children: .combine)

                        if s.id != A_Sub.all.last?.id {
                            Divider().opacity(0.35).padding(.leading, 42)
                        }
                    }
                }

                Button("Add subscription") {}
                    .font(.subheadline.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(24)
        }
        .background(Color(red: 0.05, green: 0.05, blue: 0.07).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}
