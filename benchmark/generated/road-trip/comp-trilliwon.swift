// BRIEF: "Build a SwiftUI screen for tracking a road trip in progress."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class TripModel {
    var milesTotal = 444.0
    var milesDone = 258.0
    var stops: [TripStop] = TripStop.sample
    var progress: Double { milesDone / milesTotal }
}

struct TripStop: Identifiable {
    let id = UUID()
    let name: String, detail: String
    let done: Bool
    static let sample = [
        TripStop(name: "Las Vegas", detail: "Departed 1:20 PM", done: true),
        TripStop(name: "Barstow", detail: "Fuel stop in 45 mi", done: false),
        TripStop(name: "Los Angeles", detail: "Arrive 6:45 PM", done: false),
    ]
}

@main
struct TripApp: App {
    @State private var model = TripModel()
    var body: some Scene { WindowGroup { TripView(model: model) } }
}

struct TripView: View {
    let model: TripModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Las Vegas → Los Angeles").font(.title3.weight(.semibold))
                        ProgressView(value: model.progress)
                        Text("\(Int(model.milesDone)) of \(Int(model.milesTotal)) miles · 186 to go")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("258 of 444 miles complete")
                }

                Section("Status") {
                    LabeledContent("ETA", value: "6:45 PM")
                    LabeledContent("Time remaining", value: "2h 51m")
                    LabeledContent("Speed", value: "72 mph")
                    LabeledContent("Fuel", value: "62%")
                }

                Section("Stops") {
                    ForEach(model.stops) { stop in
                        HStack {
                            Image(systemName: stop.done ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(stop.done ? .green : .secondary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(stop.name).font(.body)
                                Text(stop.detail).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(stop.name), \(stop.detail), \(stop.done ? "completed" : "upcoming")")
                    }
                }
            }
            .navigationTitle("Road Trip")
        }
    }
}
