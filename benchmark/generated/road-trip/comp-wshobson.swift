// BRIEF: "Build a SwiftUI screen for tracking a road trip in progress."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, cards, a11y)
import SwiftUI

@main
struct TripApp: App {
    var body: some Scene { WindowGroup { TripView() } }
}

struct TripView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "car.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .frame(width: 60, height: 60)
                            .background(.blue.opacity(0.1), in: Circle())
                        Text("Las Vegas → Los Angeles").font(.headline)
                        Text("Arriving 6:45 PM · 186 miles to go")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: 0.58).tint(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("58 percent complete, arriving 6:45 PM")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        infoTile("fuelpump.fill", "Fuel", "62%")
                        infoTile("speedometer", "Speed", "72 mph")
                        infoTile("clock.fill", "Time left", "2h 51m")
                        infoTile("road.lanes", "Distance", "258 / 444 mi")
                    }

                    ForEach([("checkmark.circle.fill", "Las Vegas", "Departed 1:20 PM"),
                             ("fuelpump.circle.fill", "Barstow", "Fuel stop in 45 miles"),
                             ("flag.checkered.circle.fill", "Los Angeles", "Arrive 6:45 PM")], id: \.1) { s in
                        HStack(spacing: 16) {
                            Image(systemName: s.0)
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(.blue.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(s.1).font(.headline)
                                Text(s.2).font(.subheadline).foregroundStyle(.secondary)
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
                        Label("Add Stop", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Road Trip")
        }
    }

    func infoTile(_ icon: String, _ t: String, _ v: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(.blue.opacity(0.1), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(v).font(.headline)
                Text(t).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .accessibilityElement(children: .combine)
    }
}
