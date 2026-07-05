// BRIEF: "Build a SwiftUI screen showing my monthly subscriptions."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct SubsApp: App {
    var body: some Scene { WindowGroup { SubsView() } }
}

struct SubsView: View {
    let subs = [("Netflix", "🎬", "$15.49", Color.red), ("Spotify", "🎵", "$11.99", Color.green),
                ("iCloud+", "☁️", "$2.99", Color.blue), ("Gym", "💪", "$45.00", Color.orange),
                ("YouTube Premium", "▶️", "$13.99", Color.pink)]
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("My Subscriptions 💳").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.purple, .pink],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 140)
                    .overlay(VStack(spacing: 6) {
                        Text("Total Monthly").foregroundColor(.white.opacity(0.8))
                        Text("$89.46").font(.system(size: 40)).bold().foregroundColor(.white)
                        Text("5 active subscriptions").foregroundColor(.white.opacity(0.8))
                    })
                    .shadow(radius: 8)

                ForEach(subs, id: \.0) { s in
                    HStack {
                        Text(s.1).font(.title2)
                            .padding(10).background(s.3.opacity(0.2)).clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(s.0).bold()
                            Text("Renews monthly").font(.caption).foregroundColor(.gray)
                        }
                        Spacer()
                        Text(s.2).bold().foregroundColor(s.3)
                    }
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                }

                Button(action: {}) {
                    Text("+ Add Subscription")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
