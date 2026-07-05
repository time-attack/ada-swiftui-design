// BRIEF: "Build a SwiftUI screen for tonight's moon phase."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct MoonApp: App {
    var body: some Scene { WindowGroup { MoonView() } }
}

struct MoonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Moon Phase 🌙").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.indigo, .purple],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 220)
                    .overlay(VStack(spacing: 8) {
                        Text("🌔").font(.system(size: 90))
                        Text("Waxing Gibbous").font(.title2).bold().foregroundColor(.white)
                        Text("78% Illuminated").foregroundColor(.white.opacity(0.8))
                    })
                    .shadow(radius: 8)

                HStack(spacing: 12) {
                    box("Moonrise", "6:42 PM", .orange)
                    box("Moonset", "4:18 AM", .blue)
                    box("Age", "10.3 days", .purple)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Upcoming Phases").font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach([("🌕 Full Moon", "July 10"), ("🌗 Last Quarter", "July 17"),
                             ("🌑 New Moon", "July 24")], id: \.0) { p in
                        HStack { Text(p.0); Spacer(); Text(p.1).foregroundColor(.gray) }
                            .padding().background(Color(.systemGray6)).cornerRadius(10)
                    }
                }

                Button(action: {}) {
                    Text("Notify Me at Full Moon 🔔")
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
