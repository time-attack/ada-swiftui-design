// BRIEF: "Build a SwiftUI screen for a water-intake tracker."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct WaterApp: App {
    var body: some Scene { WindowGroup { WaterView() } }
}

struct WaterView: View {
    @State private var glasses = 5
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Water Tracker 💧").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.blue, .cyan],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 160)
                    .overlay(VStack {
                        Text("Today's Progress").foregroundColor(.white.opacity(0.9))
                        Text("\(glasses) / 8 Glasses").font(.title).bold().foregroundColor(.white)
                        ProgressView(value: Double(glasses) / 8).tint(.white).padding(.horizontal, 40)
                    })
                    .shadow(radius: 8)

                HStack(spacing: 12) {
                    statBox("Streak", "12 days 🔥", .orange)
                    statBox("Goal", "2.0 L", .green)
                    statBox("Left", "0.75 L", .purple)
                }

                HStack {
                    Button(action: { glasses = max(0, glasses - 1) }) {
                        Text("- Remove").frame(maxWidth: .infinity).padding()
                            .background(Color.red).foregroundColor(.white).cornerRadius(10)
                    }
                    Button(action: { glasses = min(8, glasses + 1) }) {
                        Text("+ Add Glass").frame(maxWidth: .infinity).padding()
                            .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("History").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(["9:15 AM 🥛", "10:40 AM 🥛", "12:05 PM 🥛", "1:30 PM 🥛", "3:10 PM 🥛"], id: \.self) { h in
                        HStack { Text(h); Spacer(); Text("250 ml").foregroundColor(.gray) }
                            .padding().background(Color(.systemGray6)).cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
    func statBox(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
