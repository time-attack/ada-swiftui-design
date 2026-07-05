// BRIEF: "Build a SwiftUI screen for tonight's moon phase."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hLavender = Color(red: 0.863, green: 0.839, blue: 0.969)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)

@main
struct MoonApp: App {
    var body: some Scene { WindowGroup { MoonView() } }
}

struct MoonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Moon")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    Text("🌔").font(.system(size: 30))
                        .frame(width: 70, height: 70)
                        .background(hLavender.opacity(0.3))
                        .clipShape(Circle())
                    Text("Waxing Gibbous")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text("78% illuminated tonight")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Capsule().fill(hLavender.opacity(0.35)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hLavender)
                                    .frame(width: geo.size.width * 0.78)
                            }
                        }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    fact("Moonrise", "6:42 PM")
                    fact("Moonset", "4:18 AM")
                    fact("Age", "10.3 d")
                }

                Text("Upcoming")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    ForEach([("🌕", "Full Moon", "July 10"), ("🌗", "Last Quarter", "July 17"),
                             ("🌑", "New Moon", "July 24")], id: \.1) { p in
                        HStack(spacing: 12) {
                            Text(p.0).font(.system(size: 22))
                                .frame(width: 40, height: 40)
                                .background(hSky.opacity(0.2))
                                .clipShape(Circle())
                            Text(p.1)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Spacer()
                            Text(p.2)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Remind me at the full moon")
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

    func fact(_ t: String, _ v: String) -> some View {
        VStack(spacing: 4) {
            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
            Text(v).font(.system(size: 16, weight: .bold, design: .rounded))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
