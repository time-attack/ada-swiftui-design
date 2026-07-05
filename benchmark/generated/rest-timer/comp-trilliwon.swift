// BRIEF: "Build a SwiftUI screen for a workout rest timer."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class RestModel {
    var secondsLeft = 49
    var restLength = 90
    var currentSet = 3
    var totalSets = 5
    var exercise = "Squats"
    var weight = "185 lb"
    var timeString: String { String(format: "%d:%02d", secondsLeft / 60, secondsLeft % 60) }
    func adjust(_ delta: Int) { secondsLeft = max(0, secondsLeft + delta) }
}

@main
struct RestApp: App {
    @State private var model = RestModel()
    var body: some Scene { WindowGroup { RestView(model: model) } }
}

struct RestView: View {
    let model: RestModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Text(model.timeString)
                            .font(.system(size: 56, weight: .semibold))
                            .monospacedDigit()
                        ProgressView(value: Double(model.secondsLeft), total: Double(model.restLength))
                        Text("rest remaining")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("49 seconds of rest remaining")
                }

                Section("Current") {
                    LabeledContent("Exercise", value: model.exercise)
                    LabeledContent("Set", value: "\(model.currentSet) of \(model.totalSets)")
                    LabeledContent("Weight", value: model.weight)
                }

                Section {
                    Button { model.adjust(-15) } label: {
                        Label("Subtract 15 seconds", systemImage: "minus.circle")
                    }
                    Button { model.adjust(15) } label: {
                        Label("Add 15 seconds", systemImage: "plus.circle")
                    }
                    Button { model.secondsLeft = 0 } label: {
                        Label("Skip rest", systemImage: "forward.end")
                    }
                    .accessibilityHint("Ends the rest period now")
                }
            }
            .navigationTitle("Rest Timer")
        }
    }
}
