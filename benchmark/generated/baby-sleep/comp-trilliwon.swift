// BRIEF: "Build a SwiftUI screen for a baby sleep log."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class SleepLogModel {
    var sessions: [SleepSession] = SleepSession.sample
    var totalMinutes: Int { sessions.reduce(0) { $0 + $1.minutes } }
    var totalString: String { "\(totalMinutes / 60)h \(totalMinutes % 60)m" }
}

struct SleepSession: Identifiable {
    let id = UUID()
    let kind: String, range: String
    let minutes: Int
    static let sample = [
        SleepSession(kind: "Night sleep", range: "8:10 PM – 4:55 AM", minutes: 525),
        SleepSession(kind: "Nap 1", range: "8:30 – 9:25 AM", minutes: 55),
        SleepSession(kind: "Nap 2", range: "12:10 – 1:05 PM", minutes: 55),
        SleepSession(kind: "Nap 3", range: "3:40 – 4:25 PM", minutes: 45),
    ]
}

@main
struct BabyApp: App {
    @State private var model = SleepLogModel()
    var body: some Scene { WindowGroup { SleepLogView(model: model) } }
}

struct SleepLogView: View {
    let model: SleepLogModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.totalString).font(.largeTitle.bold()).monospacedDigit()
                        Text("total sleep today")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Total sleep today: \(model.totalString)")
                }

                Section("Today") {
                    ForEach(model.sessions) { s in
                        HStack {
                            Image(systemName: s.kind == "Night sleep" ? "moon.fill" : "moon.zzz")
                                .foregroundStyle(.indigo)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.kind).font(.body)
                                Text(s.range).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(s.minutes / 60 > 0 ? "\(s.minutes / 60)h " : "")\(s.minutes % 60)m")
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(s.kind), \(s.range), \(s.minutes) minutes")
                    }
                }

                Section {
                    Button {} label: {
                        Label("Start sleep timer", systemImage: "play.circle.fill")
                    }
                    .accessibilityHint("Begins recording a new sleep session")
                }
            }
            .navigationTitle("Sleep Log")
        }
    }
}
