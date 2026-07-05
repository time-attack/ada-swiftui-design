// BRIEF: "Build a SwiftUI screen for a flight tracker."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, FeatureCard pattern)
import SwiftUI

@main
struct FlightApp: App {
    var body: some Scene { WindowGroup { FlightView() } }
}

struct FlightView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .frame(width: 60, height: 60)
                            .background(.blue.opacity(0.1), in: Circle())
                        Text("BR 12 · EVA Air").font(.title2.bold())
                        HStack(spacing: 16) {
                            VStack { Text("TPE").font(.title3.bold()); Text("9:40 AM").font(.caption).foregroundStyle(.secondary) }
                            Image(systemName: "arrow.right").foregroundStyle(.secondary)
                            VStack { Text("LAX").font(.title3.bold()); Text("4:52 PM").font(.caption).foregroundStyle(.secondary) }
                        }
                        Gauge(value: 0.65) { EmptyView() }
                            .gaugeStyle(.linearCapacity)
                            .tint(.blue)
                        Label("On time · 65% complete", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)

                    ForEach([("door.left.hand.open", "Gate 42B, Terminal 7", "Boarding complete"),
                             ("carseat.right.fill", "Seat 14A", "Window, exit row"),
                             ("suitcase.fill", "Baggage at carousel 4", "After arrival"),
                             ("clock.fill", "11h 45m flight time", "4h 06m remaining")], id: \.1) { row in
                        HStack(spacing: 16) {
                            Image(systemName: row.0)
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(.blue.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.1).font(.headline)
                                Text(row.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {} label: {
                        Label("Share Arrival Time", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Flight Tracker")
        }
    }
}
