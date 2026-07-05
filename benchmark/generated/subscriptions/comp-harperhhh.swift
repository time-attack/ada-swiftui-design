// BRIEF: "Build a SwiftUI screen showing my monthly subscriptions."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji chips)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hLavender = Color(red: 0.863, green: 0.839, blue: 0.969)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)

@main
struct SubsApp: App {
    var body: some Scene { WindowGroup { SubsView() } }
}

struct SubsView: View {
    let subs: [(String, String, String, Color)] = [
        ("Netflix", "🎬", "$15.49", hPeach),
        ("Spotify", "🎵", "$11.99", hSage),
        ("iCloud+", "☁️", "$2.99", hSky),
        ("Gym", "🏃", "$45.00", hLavender),
        ("YouTube Premium", "▶️", "$13.99", hPeach),
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Subscriptions")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly total")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Text("$89.46")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("5 active · next renewal in 3 days")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                VStack(spacing: 12) {
                    ForEach(subs, id: \.0) { s in
                        HStack(spacing: 12) {
                            Text(s.1).font(.system(size: 22))
                                .frame(width: 44, height: 44)
                                .background(s.3.opacity(0.35))
                                .clipShape(Circle())
                            Text(s.0)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Spacer()
                            Text(s.2)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .monospacedDigit()
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Add subscription")
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
}
