// BRIEF: "Build a SwiftUI screen for a podcast player."
// VARIANT: comp-trilliwon (@Observable, semantic fonts, a11y; no visual direction)
import SwiftUI

@Observable final class PlayerModel {
    var isPlaying = true
    var position: Double = 1102   // seconds
    var duration: Double = 3130
    var speed = 1.5
    var episode = "Ep. 214: The Future of AI"
    var show = "Tech Talk Weekly"
    var positionString: String {
        String(format: "%d:%02d", Int(position) / 60, Int(position) % 60)
    }
    var durationString: String {
        String(format: "%d:%02d", Int(duration) / 60, Int(duration) % 60)
    }
    func togglePlay() { isPlaying.toggle() }
}

@main
struct PodcastApp: App {
    @State private var model = PlayerModel()
    var body: some Scene { WindowGroup { PlayerView(model: model) } }
}

struct PlayerView: View {
    let model: PlayerModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(model.episode).font(.headline)
                        Text(model.show).font(.subheadline).foregroundStyle(.secondary)
                        ProgressView(value: model.position, total: model.duration)
                        HStack {
                            Text(model.positionString).font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(model.durationString).font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(model.episode), \(model.positionString) of \(model.durationString)")
                }

                Section("Playback") {
                    Button {
                        model.togglePlay()
                    } label: {
                        Label(model.isPlaying ? "Pause" : "Play",
                              systemImage: model.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .accessibilityHint("Toggles playback")
                    Button { model.position = max(0, model.position - 15) } label: {
                        Label("Back 15 seconds", systemImage: "gobackward.15")
                    }
                    Button { model.position = min(model.duration, model.position + 30) } label: {
                        Label("Forward 30 seconds", systemImage: "goforward.30")
                    }
                    LabeledContent("Speed", value: "1.5×")
                }

                Section("Up Next") {
                    ForEach(["Ep. 215: Chips and Power", "Ep. 216: Agents at Work"], id: \.self) { e in
                        Text(e).font(.body)
                    }
                }
            }
            .navigationTitle("Now Playing")
        }
    }
}
