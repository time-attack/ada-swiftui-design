// BRIEF: "Build a SwiftUI screen for tonight's moon phase."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, cards, a11y)
import SwiftUI

@main
struct MoonApp: App {
    var body: some Scene { WindowGroup { MoonView() } }
}

struct MoonView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "moonphase.waxing.gibbous")
                            .font(.system(size: 56))
                            .foregroundStyle(.indigo)
                            .frame(width: 90, height: 90)
                            .background(.indigo.opacity(0.1), in: Circle())
                        Text("Waxing Gibbous").font(.title2.bold())
                        Text("78% illuminated")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Gauge(value: 0.78) { EmptyView() }
                            .gaugeStyle(.linearCapacity)
                            .tint(.indigo)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Waxing gibbous, 78 percent illuminated")

                    ForEach([("sunrise.fill", "Moonrise", "6:42 PM"),
                             ("sunset.fill", "Moonset", "4:18 AM"),
                             ("calendar", "Moon age", "10.3 days")], id: \.1) { row in
                        HStack(spacing: 16) {
                            Image(systemName: row.0)
                                .font(.title3)
                                .foregroundStyle(.indigo)
                                .frame(width: 44, height: 44)
                                .background(.indigo.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.1).font(.headline)
                                Text(row.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Upcoming Phases").font(.headline).padding(.bottom, 8)
                        ForEach([("moonphase.full.moon", "Full Moon", "July 10"),
                                 ("moonphase.last.quarter", "Last Quarter", "July 17"),
                                 ("moonphase.new.moon", "New Moon", "July 24")], id: \.1) { p in
                            HStack {
                                Image(systemName: p.0).foregroundStyle(.indigo)
                                Text(p.1).font(.body)
                                Spacer()
                                Text(p.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                            .accessibilityElement(children: .combine)
                        }
                    }
                    .padding()
                    .background(.background, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)

                    Button {} label: {
                        Label("Notify at Full Moon", systemImage: "bell.badge")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Moon Phase")
        }
    }
}
