// BRIEF: "Build a SwiftUI screen for a parking meter timer."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hPeach = Color(red: 1.0, green: 0.867, blue: 0.682)
let hLavender = Color(red: 0.863, green: 0.839, blue: 0.969)

@main
struct ParkingApp: App {
    var body: some Scene { WindowGroup { MeterView() } }
}

struct MeterView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Parking")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(spacing: 12) {
                    Text("🚗").font(.system(size: 28))
                        .frame(width: 60, height: 60)
                        .background(hPeach.opacity(0.4))
                        .clipShape(Circle())
                    Text("48:12")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("left on your meter")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(hSecondaryText)
                    Capsule().fill(hPeach.opacity(0.35)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hPeach)
                                    .frame(width: geo.size.width * 0.40)
                            }
                        }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    detail("Zone", "4B")
                    detail("Spot", "112")
                    detail("Rate", "$2/hr")
                }

                Text("Extend 30 minutes · $1.00")
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

    func detail(_ t: String, _ v: String) -> some View {
        VStack(spacing: 4) {
            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
            Text(v).font(.system(size: 18, weight: .bold, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(hLavender.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
