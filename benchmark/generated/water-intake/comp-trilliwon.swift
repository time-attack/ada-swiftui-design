// BRIEF: "Build a SwiftUI screen for a water-intake tracker."
// VARIANT: comp-trilliwon — trilliwon SwiftUI Best Practices applied
// (@Observable model, semantic fonts, Dynamic Type, a11y labels, lazy lists,
//  stable identifiers; the rules give no visual-design direction).
import SwiftUI

@Observable final class WaterModel {
    var entries: [WaterEntry] = WaterEntry.sample
    var goalML = 2000
    var totalML: Int { entries.reduce(0) { $0 + $1.amountML } }
    var progress: Double { min(1, Double(totalML) / Double(goalML)) }
    func addGlass() { entries.append(WaterEntry(time: "Now", amountML: 250)) }
}

struct WaterEntry: Identifiable {
    let id = UUID()
    let time: String
    let amountML: Int
    static let sample = [
        WaterEntry(time: "9:15 AM", amountML: 250),
        WaterEntry(time: "10:40 AM", amountML: 250),
        WaterEntry(time: "12:05 PM", amountML: 350),
        WaterEntry(time: "1:30 PM", amountML: 250),
        WaterEntry(time: "3:10 PM", amountML: 150),
    ]
}

@main
struct WaterApp: App {
    @State private var model = WaterModel()
    var body: some Scene { WindowGroup { WaterView(model: model) } }
}

struct WaterView: View {
    let model: WaterModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(model.totalML) ml of \(model.goalML) ml")
                            .font(.title2)
                        ProgressView(value: model.progress)
                        Text("\(Int(model.progress * 100))% of your daily goal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Progress: \(model.totalML) of \(model.goalML) milliliters")
                }

                Section("Today") {
                    ForEach(model.entries) { entry in
                        HStack {
                            Label("\(entry.amountML) ml", systemImage: "drop")
                            Spacer()
                            Text(entry.time)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(entry.amountML) milliliters at \(entry.time)")
                    }
                }

                Section {
                    Button {
                        model.addGlass()
                    } label: {
                        Label("Add a glass (250 ml)", systemImage: "plus.circle.fill")
                    }
                    .accessibilityHint("Adds 250 milliliters to today's total")
                }
            }
            .navigationTitle("Water")
        }
    }
}
