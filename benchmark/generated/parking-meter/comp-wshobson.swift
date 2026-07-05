// BRIEF: "Build a SwiftUI screen for a parking meter timer."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, materials, cards)
import SwiftUI

@main
struct ParkingApp: App {
    var body: some Scene { WindowGroup { MeterView() } }
}

struct MeterView: View {
    @State private var secondsLeft = 2892

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "parkingsign.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .frame(width: 60, height: 60)
                            .background(.blue.opacity(0.1), in: Circle())
                        Text("48:12")
                            .font(.system(size: 54, weight: .bold))
                            .monospacedDigit()
                        Text("Time remaining")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Gauge(value: 0.40) { EmptyView() }
                            .gaugeStyle(.linearCapacity)
                            .tint(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("48 minutes 12 seconds remaining")

                    ForEach([("mappin.circle.fill", "Zone 4B, Spot 112", "Ventura Blvd"),
                             ("dollarsign.circle.fill", "$2.00 per hour", "Charged to Apple Pay"),
                             ("clock.fill", "Expires 3:42 PM", "Reminder 10 min before")], id: \.1) { row in
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
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {
                        secondsLeft += 1800
                    } label: {
                        Label("Extend 30 Minutes", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)

                    Button(role: .destructive) {} label: {
                        Text("End Session")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Parking Meter")
        }
    }
}
