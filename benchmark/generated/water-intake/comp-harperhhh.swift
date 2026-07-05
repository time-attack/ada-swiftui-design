// BRIEF: "Build a SwiftUI screen for a water-intake tracker."
// VARIANT: comp-harperhhh — SwiftUI Design Philosophy applied
// (#F9F9F9 bg, white cards r18 continuous + 0.04 shadows, SF Rounded explicit
//  sizes, pastel accents at low opacity, emoji accents in tinted circles,
//  dark full-width primary button, 24pt page padding).
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)

@main
struct WaterApp: App {
    var body: some Scene { WindowGroup { WaterView() } }
}

struct WaterView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Water")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                // hero card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Text("💧").font(.system(size: 26))
                            .frame(width: 52, height: 52)
                            .background(hSky.opacity(0.3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text("1,250 ml")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                            Text("of 2,000 ml today")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                    }
                    Capsule().fill(hSky.opacity(0.3)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hSky)
                                    .frame(width: geo.size.width * 0.62)
                            }
                        }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                Text("Today")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    ForEach([("9:15 AM", "250 ml"), ("10:40 AM", "250 ml"),
                             ("12:05 PM", "350 ml"), ("1:30 PM", "250 ml"),
                             ("3:10 PM", "150 ml")], id: \.0) { e in
                        HStack(spacing: 12) {
                            Text("🥛").font(.system(size: 22))
                                .frame(width: 40, height: 40)
                                .background(hSky.opacity(0.15))
                                .clipShape(Circle())
                            Text(e.0)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                            Spacer()
                            Text(e.1)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Add a glass")
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
