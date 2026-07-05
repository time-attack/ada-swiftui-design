// BRIEF: "Build a SwiftUI screen for a podcast player."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, materials, cards)
import SwiftUI

@main
struct PodcastApp: App {
    var body: some Scene { WindowGroup { PlayerView() } }
}

struct PlayerView: View {
    @State private var isPlaying = true
    @State private var progress = 0.35

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "waveform.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.blue)
                            .frame(width: 120, height: 120)
                            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                        Text("Ep. 214: The Future of AI").font(.headline)
                        Text("Tech Talk Weekly").font(.subheadline).foregroundStyle(.secondary)
                        ProgressView(value: progress).tint(.blue)
                        HStack {
                            Text("18:22").font(.caption).monospacedDigit().foregroundStyle(.secondary)
                            Spacer()
                            Text("52:10").font(.caption).monospacedDigit().foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Episode 214, 18 minutes 22 of 52 minutes 10")

                    HStack(spacing: 20) {
                        Button {} label: {
                            Image(systemName: "gobackward.15").font(.title2)
                                .frame(width: 52, height: 52)
                        }
                        .buttonStyle(.bordered)
                        .clipShape(Circle())
                        Button { isPlaying.toggle() } label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                                .frame(width: 68, height: 68)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(Circle())
                        .accessibilityLabel(isPlaying ? "Pause" : "Play")
                        Button {} label: {
                            Image(systemName: "goforward.30").font(.title2)
                                .frame(width: 52, height: 52)
                        }
                        .buttonStyle(.bordered)
                        .clipShape(Circle())
                    }

                    HStack(spacing: 16) {
                        Image(systemName: "speedometer")
                            .font(.title3)
                            .foregroundStyle(.blue)
                            .frame(width: 44, height: 44)
                            .background(.blue.opacity(0.1), in: Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Playback Speed").font(.headline)
                            Text("1.5× — saves 17 minutes").font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.tertiary)
                    }
                    .padding()
                    .background(.background, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    .accessibilityElement(children: .combine)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Now Playing")
        }
    }
}
