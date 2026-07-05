// BRIEF: "Build a SwiftUI screen for a flight tracker."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class FlightModel {
    var number = "BR 12"
    var airline = "EVA Air"
    var from = "TPE"
    var to = "LAX"
    var progress = 0.65
    var status = "On time"
}

@main
struct FlightApp: App {
    @State private var model = FlightModel()
    var body: some Scene { WindowGroup { FlightView(model: model) } }
}

struct FlightView: View {
    let model: FlightModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(model.number) · \(model.airline)").font(.title2.bold())
                        Text("\(model.from) → \(model.to)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: model.progress)
                        Text("\(Int(model.progress * 100))% complete · \(model.status)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Flight \(model.number), \(model.from) to \(model.to), 65 percent complete, on time")
                }
                Section("Times") {
                    LabeledContent("Departs", value: "9:40 AM TPE")
                    LabeledContent("Arrives", value: "4:52 PM LAX")
                    LabeledContent("Duration", value: "11h 45m")
                }
                Section("Details") {
                    LabeledContent("Gate", value: "42B")
                    LabeledContent("Terminal", value: "7")
                    LabeledContent("Seat", value: "14A")
                    LabeledContent("Aircraft", value: "Boeing 777-300ER")
                    LabeledContent("Baggage", value: "Carousel 4")
                }
                Section {
                    Button {} label: {
                        Label("Share arrival time", systemImage: "square.and.arrow.up")
                    }
                    .accessibilityHint("Shares the estimated arrival time")
                }
            }
            .navigationTitle("Flight")
        }
    }
}
