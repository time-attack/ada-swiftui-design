// BRIEF: "Build a SwiftUI screen for a workout rest timer."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct RestApp: App {
    var body: some Scene { WindowGroup { RestView() } }
}

struct RestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Rest Timer 💪").font(.largeTitle).bold()

            ZStack {
                Circle().stroke(Color(.systemGray5), lineWidth: 16)
                Circle().trim(from: 0, to: 0.55)
                    .stroke(LinearGradient(colors: [.green, .blue],
                                           startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("0:49").font(.system(size: 52)).bold()
                    Text("rest remaining").foregroundColor(.gray)
                }
            }
            .frame(width: 230, height: 230)
            .shadow(radius: 5)

            HStack(spacing: 12) {
                card("Set", "3 / 5", .blue)
                card("Exercise", "Squats 🏋️", .purple)
                card("Weight", "185 lb", .orange)
            }

            HStack {
                Button("-15s") {}.frame(maxWidth: .infinity).padding()
                    .background(Color.gray).foregroundColor(.white).cornerRadius(10)
                Button("Skip Rest ⏭") {}.frame(maxWidth: .infinity).padding()
                    .background(Color.green).foregroundColor(.white).cornerRadius(10)
                Button("+15s") {}.frame(maxWidth: .infinity).padding()
                    .background(Color.gray).foregroundColor(.white).cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
    func card(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
