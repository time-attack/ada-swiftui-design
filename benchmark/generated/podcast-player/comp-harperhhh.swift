// BRIEF: "Build a SwiftUI screen for a podcast player."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hLavender = Color(red: 0.863, green: 0.839, blue: 0.969)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)

@main
struct PodcastApp: App {
    var body: some Scene { WindowGroup { PlayerView() } }
}

struct PlayerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Now Playing")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 16) {
                    Text("🎙️").font(.system(size: 30))
                        .frame(width: 70, height: 70)
                        .background(hLavender.opacity(0.4))
                        .clipShape(Circle())
                    VStack(spacing: 4) {
                        Text("Ep. 214: The Future of AI")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        Text("Tech Talk Weekly")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(hSecondaryText)
                    }
                    VStack(spacing: 6) {
                        Capsule().fill(hLavender.opacity(0.35)).frame(height: 10)
                            .overlay(alignment: .leading) {
                                GeometryReader { geo in
                                    Capsule().fill(hLavender)
                                        .frame(width: geo.size.width * 0.35)
                                }
                            }
                        HStack {
                            Text("18:22")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                            Spacer()
                            Text("52:10")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    chip("⏪", "15s")
                    chip("⏩", "30s")
                    chip("⚡️", "1.5×")
                    chip("🌙", "Sleep")
                }

                Text("Play")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(hPrimaryText)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(hBackground)
        .foregroundStyle(hPrimaryText)
    }

    func chip(_ emoji: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 22))
                .frame(width: 44, height: 44)
                .background(hPeach.opacity(0.3))
                .clipShape(Circle())
            Text(label)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
