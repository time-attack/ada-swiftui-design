// BRIEF: "Build a SwiftUI screen for a pomodoro focus session."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct PomoApp: App {
    var body: some Scene { WindowGroup { PomoView() } }
}

struct PomoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Pomodoro Timer 🍅").font(.largeTitle).bold()

            ZStack {
                Circle().stroke(Color(.systemGray5), lineWidth: 16)
                Circle().trim(from: 0, to: 0.68)
                    .stroke(LinearGradient(colors: [.red, .orange],
                                           startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("17:03").font(.system(size: 50)).bold()
                    Text("Focus Time 🎯").foregroundColor(.gray)
                }
            }
            .frame(width: 230, height: 230)
            .shadow(radius: 5)

            HStack(spacing: 12) {
                card("Session", "2 / 4", .red)
                card("Task", "Write essay ✍️", .blue)
                card("Breaks", "5 min", .green)
            }

            HStack {
                Button("Pause ⏸") {}.frame(maxWidth: .infinity).padding()
                    .background(Color.orange).foregroundColor(.white).cornerRadius(10)
                Button("Give Up ❌") {}.frame(maxWidth: .infinity).padding()
                    .background(Color.red).foregroundColor(.white).cornerRadius(10)
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
