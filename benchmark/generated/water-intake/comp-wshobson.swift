// BRIEF: "Build a SwiftUI screen for a water-intake tracker."
// VARIANT: comp-wshobson — mobile-ios-design (HIG) applied
// (semantic colors/fonts, SF Symbols in tinted circles, FeatureCard pattern,
//  NavigationStack, standard card shadows, accessibility modifiers).
import SwiftUI

@main
struct WaterApp: App {
    var body: some Scene { WindowGroup { WaterView() } }
}

struct WaterView: View {
    @State private var totalML = 1250
    private let goalML = 2000

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // summary card
                    VStack(spacing: 12) {
                        Image(systemName: "drop.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .frame(width: 60, height: 60)
                            .background(.blue.opacity(0.1), in: Circle())
                        Text("\(totalML) ml")
                            .font(.largeTitle.bold())
                        Text("of \(goalML) ml daily goal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: Double(totalML), total: Double(goalML))
                            .tint(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(totalML) of \(goalML) milliliters, \(totalML * 100 / goalML) percent")

                    // feature-card rows
                    ForEach(entries, id: \.time) { e in
                        HStack(spacing: 16) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(.blue.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(e.amount) ml").font(.headline)
                                Text(e.time).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {
                        totalML += 250
                    } label: {
                        Label("Add Glass", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("Adds 250 milliliters")
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Water Intake")
        }
    }

    private var entries: [(time: String, amount: Int)] {
        [("9:15 AM", 250), ("10:40 AM", 250), ("12:05 PM", 350),
         ("1:30 PM", 250), ("3:10 PM", 150)]
    }
}
