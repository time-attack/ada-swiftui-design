// BRIEF: "Build a SwiftUI screen for a baby sleep log."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hLavender = Color(red: 0.863, green: 0.839, blue: 0.969)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)

@main
struct BabyApp: App {
    var body: some Scene { WindowGroup { SleepLogView() } }
}

struct SleepLogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sleep log")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    Text("😴").font(.system(size: 28))
                        .frame(width: 60, height: 60)
                        .background(hLavender.opacity(0.4))
                        .clipShape(Circle())
                    Text("11h 20m")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("total sleep today")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                Text("Today")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    ForEach([("🌙", "Night sleep", "8:10 PM – 4:55 AM", "8h 45m", hLavender),
                             ("☁️", "Nap 1", "8:30 – 9:25 AM", "55m", hSky),
                             ("☁️", "Nap 2", "12:10 – 1:05 PM", "55m", hSky),
                             ("☁️", "Nap 3", "3:40 – 4:25 PM", "45m", hSky)], id: \.2) { s in
                        HStack(spacing: 12) {
                            Text(s.0).font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(s.4.opacity(0.3))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.1).font(.system(size: 16, weight: .bold, design: .rounded))
                                Text(s.2).font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(hSecondaryText)
                            }
                            Spacer()
                            Text(s.3)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(hSecondaryText)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Start sleep timer")
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
