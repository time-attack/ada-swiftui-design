// BRIEF: "Build a SwiftUI screen for tracking a road trip in progress."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)

@main
struct TripApp: App {
    var body: some Scene { WindowGroup { TripView() } }
}

struct TripView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Road trip")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Text("🚗").font(.system(size: 26))
                            .frame(width: 52, height: 52)
                            .background(hPeach.opacity(0.4))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Vegas → LA")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            Text("Arriving 6:45 PM")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                    }
                    Capsule().fill(hPeach.opacity(0.35)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hPeach)
                                    .frame(width: geo.size.width * 0.58)
                            }
                        }
                    Text("258 of 444 miles")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    stat("⛽️", "Fuel", "62%", hSage)
                    stat("⏱", "Left", "2h 51m", hSky)
                    stat("🛣", "Speed", "72 mph", hPeach)
                }

                Text("Stops")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    ForEach([("Las Vegas", "Departed 1:20 PM", "✅"),
                             ("Barstow", "Fuel stop · 45 mi ahead", "⛽️"),
                             ("Los Angeles", "Arrive 6:45 PM", "🏁")], id: \.0) { s in
                        HStack(spacing: 12) {
                            Text(s.2).font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(hSky.opacity(0.2))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.0).font(.system(size: 16, weight: .bold, design: .rounded))
                                Text(s.1).font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(hSecondaryText)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }

                Text("Add a stop")
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

    func stat(_ emoji: String, _ t: String, _ v: String, _ tint: Color) -> some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.3))
                .clipShape(Circle())
            Text(v).font(.system(size: 16, weight: .bold, design: .rounded))
            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
