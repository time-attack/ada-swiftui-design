// BRIEF: "Build a SwiftUI screen for a podcast player."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct PodcastApp: App {
    var body: some Scene { WindowGroup { PodcastView() } }
}

struct PodcastView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Now Playing 🎙️").font(.largeTitle).bold()

            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.orange, .pink],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 250, height: 250)
                .overlay(Text("🎙️").font(.system(size: 80)))
                .shadow(radius: 8)

            VStack(spacing: 4) {
                Text("Ep. 214: The Future of AI").font(.title3).bold()
                Text("Tech Talk Weekly").foregroundColor(.gray)
            }

            Slider(value: .constant(0.35)).padding(.horizontal)
            HStack {
                Text("18:22").font(.caption).foregroundColor(.gray)
                Spacer()
                Text("52:10").font(.caption).foregroundColor(.gray)
            }.padding(.horizontal)

            HStack(spacing: 24) {
                Button("⏪ 15") {}.padding().background(Color.blue.opacity(0.2)).cornerRadius(30)
                Button("▶️") {}.font(.title).padding(24).background(Color.blue).clipShape(Circle())
                Button("30 ⏩") {}.padding().background(Color.blue.opacity(0.2)).cornerRadius(30)
            }

            HStack(spacing: 12) {
                Button("1.5x Speed") {}.padding(10).background(Color(.systemGray6)).cornerRadius(8)
                Button("Sleep Timer 😴") {}.padding(10).background(Color(.systemGray6)).cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}
