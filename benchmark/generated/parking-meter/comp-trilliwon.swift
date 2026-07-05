// BRIEF: "Build a SwiftUI screen for a parking meter timer."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class MeterModel {
    var secondsLeft = 2892
    var zone = "4B"
    var ratePerHour = 2.0
    var timeString: String {
        String(format: "%d:%02d", secondsLeft / 60, secondsLeft % 60)
    }
    func extend(minutes: Int) { secondsLeft += minutes * 60 }
}

@main
struct ParkingApp: App {
    @State private var model = MeterModel()
    var body: some Scene { WindowGroup { MeterView(model: model) } }
}

struct MeterView: View {
    let model: MeterModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Text(model.timeString)
                            .font(.system(size: 56, weight: .semibold))
                            .monospacedDigit()
                        Text("remaining")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("48 minutes 12 seconds remaining")
                }

                Section("Session") {
                    LabeledContent("Zone", value: model.zone)
                    LabeledContent("Rate", value: "$2.00 / hour")
                    LabeledContent("Spot", value: "112")
                    LabeledContent("Expires", value: "3:42 PM")
                }

                Section {
                    Button {
                        model.extend(minutes: 30)
                    } label: {
                        Label("Extend 30 minutes ($1.00)", systemImage: "plus.circle")
                    }
                    .accessibilityHint("Charges one dollar and adds 30 minutes")
                    Button(role: .destructive) {} label: {
                        Label("End session", systemImage: "xmark.circle")
                    }
                }
            }
            .navigationTitle("Parking")
        }
    }
}
