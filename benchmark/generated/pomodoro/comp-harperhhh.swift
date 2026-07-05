// BRIEF: "Build a SwiftUI screen for a pomodoro focus session."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)

@main
struct PomodoroApp: App {
    var body: some Scene { WindowGroup { PomodoroView() } }
}

struct PomodoroView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Focus")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    Text("🍅").font(.system(size: 28))
                        .frame(width: 60, height: 60)
                        .background(hPeach.opacity(0.4))
                        .clipShape(Circle())
                    Text("17:03")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("Write essay outline")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Capsule().fill(hPeach.opacity(0.35)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hPeach)
                                    .frame(width: geo.size.width * 0.32)
                            }
                        }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                Text("Today's blocks")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { i in
                        VStack(spacing: 6) {
                            Text(i < 2 ? "✅" : (i == 2 ? "🍅" : "⭕️"))
                                .font(.system(size: 20))
                            Text("Block \(i + 1)")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(i == 2 ? hSage.opacity(0.5) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Pause")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(hPrimaryText)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                Text("End session")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(hSecondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(hBackground)
        .foregroundStyle(hPrimaryText)
    }
}
