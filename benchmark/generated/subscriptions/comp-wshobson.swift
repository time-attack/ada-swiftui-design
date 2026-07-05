// BRIEF: "Build a SwiftUI screen showing my monthly subscriptions."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, FeatureCard rows)
import SwiftUI

@main
struct SubsApp: App {
    var body: some Scene { WindowGroup { SubsView() } }
}

struct SubsView: View {
    let subs = [("play.tv.fill", "Netflix", "Renews July 8", "$15.49", Color.red),
                ("music.note", "Spotify", "Renews July 12", "$11.99", Color.green),
                ("icloud.fill", "iCloud+", "Renews July 15", "$2.99", Color.blue),
                ("dumbbell.fill", "Gym Membership", "Renews July 21", "$45.00", Color.orange),
                ("play.rectangle.fill", "YouTube Premium", "Renews July 27", "$13.99", Color.pink)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Image(systemName: "creditcard.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .frame(width: 60, height: 60)
                            .background(.blue.opacity(0.1), in: Circle())
                        Text("$89.46").font(.largeTitle.bold()).monospacedDigit()
                        Text("per month · 5 subscriptions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)

                    ForEach(subs, id: \.1) { s in
                        HStack(spacing: 16) {
                            Image(systemName: s.0)
                                .font(.title3)
                                .foregroundStyle(s.4)
                                .frame(width: 44, height: 44)
                                .background(s.4.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(s.1).font(.headline)
                                Text(s.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(s.3).font(.headline).monospacedDigit()
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {} label: {
                        Label("Add Subscription", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Subscriptions")
        }
    }
}
