// BRIEF: "Build a SwiftUI screen for a workout rest timer."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)

@main
struct RestApp: App {
    var body: some Scene { WindowGroup { RestView() } }
}

struct RestView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Rest")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    Text("💪").font(.system(size: 28))
                        .frame(width: 60, height: 60)
                        .background(hSage.opacity(0.5))
                        .clipShape(Circle())
                    Text("0:49")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("until your next set")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Capsule().fill(hSage.opacity(0.4)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hSage)
                                    .frame(width: geo.size.width * 0.55)
                            }
                        }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    stat("Set", "3 / 5")
                    stat("Exercise", "Squats")
                    stat("Weight", "185 lb")
                }

                HStack(spacing: 12) {
                    Text("−15s")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    Text("+15s")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                }

                Text("Skip rest — I'm ready")
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

    func stat(_ t: String, _ v: String) -> some View {
        VStack(spacing: 4) {
            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
            Text(v).font(.system(size: 16, weight: .bold, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(hPeach.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
