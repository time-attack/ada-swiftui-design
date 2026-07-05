// BRIEF: "Build a SwiftUI screen for a pomodoro focus session."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class PomodoroModel {
    var secondsLeft = 1023
    var session = 2
    var totalSessions = 4
    var task = "Write essay outline"
    var isRunning = true
    var timeString: String {
        String(format: "%d:%02d", secondsLeft / 60, secondsLeft % 60)
    }
    func togglePause() { isRunning.toggle() }
}

@main
struct PomodoroApp: App {
    @State private var model = PomodoroModel()
    var body: some Scene { WindowGroup { PomodoroView(model: model) } }
}

struct PomodoroView: View {
    let model: PomodoroModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Text(model.timeString)
                            .font(.system(size: 56, weight: .semibold))
                            .monospacedDigit()
                        Text("focus remaining")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: 1 - Double(model.secondsLeft) / 1500)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("17 minutes 3 seconds of focus remaining")
                }

                Section("Session") {
                    LabeledContent("Block", value: "\(model.session) of \(model.totalSessions)")
                    LabeledContent("Task", value: model.task)
                    LabeledContent("Next break", value: "5 minutes")
                }

                Section {
                    Button {
                        model.togglePause()
                    } label: {
                        Label(model.isRunning ? "Pause" : "Resume",
                              systemImage: model.isRunning ? "pause.circle" : "play.circle")
                    }
                    Button(role: .destructive) {} label: {
                        Label("End session", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Pomodoro")
        }
    }
}
