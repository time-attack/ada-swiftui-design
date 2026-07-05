// BRIEF: "Build a SwiftUI screen for tonight's moon phase."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class MoonModel {
    var phaseName = "Waxing Gibbous"
    var illumination = 78
    var moonrise = "6:42 PM"
    var moonset = "4:18 AM"
    var ageDays = 10.3
    var upcoming: [MoonEvent] = MoonEvent.sample
}

struct MoonEvent: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    static let sample = [
        MoonEvent(name: "Full Moon", date: "July 10"),
        MoonEvent(name: "Last Quarter", date: "July 17"),
        MoonEvent(name: "New Moon", date: "July 24"),
    ]
}

@main
struct MoonApp: App {
    @State private var model = MoonModel()
    var body: some Scene { WindowGroup { MoonView(model: model) } }
}

struct MoonView: View {
    let model: MoonModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 6) {
                        Image(systemName: "moonphase.waxing.gibbous")
                            .font(.system(size: 64))
                        Text(model.phaseName).font(.title2)
                        Text("\(model.illumination)% illuminated")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(model.phaseName), \(model.illumination) percent illuminated")
                }

                Section("Tonight") {
                    LabeledContent("Moonrise", value: model.moonrise)
                    LabeledContent("Moonset", value: model.moonset)
                    LabeledContent("Moon age", value: String(format: "%.1f days", model.ageDays))
                }

                Section("Upcoming phases") {
                    ForEach(model.upcoming) { e in
                        LabeledContent(e.name, value: e.date)
                            .accessibilityElement(children: .combine)
                    }
                }

                Section {
                    Button {} label: {
                        Label("Notify me at the full moon", systemImage: "bell")
                    }
                    .accessibilityHint("Schedules a notification for July 10")
                }
            }
            .navigationTitle("Moon")
        }
    }
}
