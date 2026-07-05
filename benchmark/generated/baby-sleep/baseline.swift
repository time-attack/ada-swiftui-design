// BRIEF: "Build a SwiftUI screen for a baby sleep log."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct BabyApp: App {
    var body: some Scene { WindowGroup { BabyView() } }
}

struct BabyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Baby Sleep Log 👶").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.purple, .blue],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 140)
                    .overlay(VStack(spacing: 6) {
                        Text("Total Sleep Today 😴").foregroundColor(.white.opacity(0.85))
                        Text("11h 20m").font(.system(size: 40)).bold().foregroundColor(.white)
                        Text("Great job! 🌟").foregroundColor(.yellow)
                    })
                    .shadow(radius: 8)

                HStack(spacing: 12) {
                    box("Naps", "3", .orange)
                    box("Night Sleep", "8h 45m", .indigo)
                    box("Avg Nap", "51 min", .pink)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Sleep").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach([("🌙 Night", "8:10 PM - 4:55 AM", "8h 45m"),
                             ("😴 Nap 1", "8:30 - 9:25 AM", "55 min"),
                             ("😴 Nap 2", "12:10 - 1:05 PM", "55 min"),
                             ("😴 Nap 3", "3:40 - 4:25 PM", "45 min")], id: \.0) { n in
                        HStack {
                            Text(n.0)
                            VStack(alignment: .leading) {
                                Text(n.1).font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Text(n.2).bold()
                        }
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("Start Sleep Timer 🛏")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
    func box(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
