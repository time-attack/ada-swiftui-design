// BRIEF: "Build a SwiftUI screen for a flight tracker."
// VARIANT: comp-harperhhh (pastel tokens, SF Rounded, white cards, emoji accents)
import SwiftUI

let hBackground = Color(red: 0.976, green: 0.976, blue: 0.976)
let hPrimaryText = Color(red: 0.176, green: 0.176, blue: 0.176)
let hSecondaryText = Color(red: 0.557, green: 0.557, blue: 0.576)
let hSky = Color(red: 0.776, green: 0.906, blue: 1.0)
let hSage = Color(red: 0.882, green: 0.918, blue: 0.804)

@main
struct FlightApp: App {
    var body: some Scene { WindowGroup { FlightView() } }
}

struct FlightView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Flight")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Text("✈️").font(.system(size: 24))
                            .frame(width: 52, height: 52)
                            .background(hSky.opacity(0.35))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BR 12 · EVA Air")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            Text("On time")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(hSage.opacity(0.6))
                                .clipShape(Capsule())
                        }
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TPE").font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("9:40 AM").font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                        Spacer()
                        Text("11h 45m")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(hSecondaryText)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("LAX").font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("4:52 PM").font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(hSecondaryText)
                        }
                    }
                    Capsule().fill(hSky.opacity(0.35)).frame(height: 10)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                Capsule().fill(hSky).frame(width: geo.size.width * 0.65)
                            }
                        }
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)

                HStack(spacing: 12) {
                    chip("Gate", "42B")
                    chip("Terminal", "7")
                    chip("Seat", "14A")
                }

                VStack(spacing: 12) {
                    row("🧳", "Baggage", "Carousel 4")
                    row("🛫", "Aircraft", "777-300ER")
                }

                Text("Share arrival time")
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

    func chip(_ t: String, _ v: String) -> some View {
        VStack(spacing: 4) {
            Text(t).font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
            Text(v).font(.system(size: 18, weight: .bold, design: .rounded))
        }
        .frame(maxWidth: .infinity).padding(16)
        .background(hSky.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    func row(_ e: String, _ t: String, _ v: String) -> some View {
        HStack(spacing: 12) {
            Text(e).font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(hSky.opacity(0.18)).clipShape(Circle())
            Text(t).font(.system(size: 16, weight: .medium, design: .rounded))
            Spacer()
            Text(v).font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(hSecondaryText)
        }
        .padding(16).background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
