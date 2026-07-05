// BRIEF: "Build a SwiftUI screen for tracking a road trip in progress."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct TripApp: App {
    var body: some Scene { WindowGroup { TripView() } }
}

struct TripView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Road Trip 🚗").font(.largeTitle).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray4))
                    .frame(height: 170)
                    .overlay(Text("🗺️ Map View").font(.title2))

                ProgressView(value: 0.58).padding(.horizontal)
                Text("58% Complete — 186 miles to go").font(.caption).foregroundColor(.gray)

                HStack(spacing: 12) {
                    box("ETA", "6:45 PM", .blue)
                    box("Fuel", "62%", .green)
                    box("Speed", "72 mph", .orange)
                }
                HStack(spacing: 12) {
                    box("Distance", "258 mi", .purple)
                    box("Time Left", "2h 51m", .red)
                    box("Next Stop", "45 mi ⛽️", .teal)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Stops").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    ForEach([("Las Vegas ✅", "Departed 1:20 PM"), ("Barstow ⛽️", "Next - 45 mi"),
                             ("Los Angeles 🏁", "Arrive 6:45 PM")], id: \.0) { s in
                        HStack { Text(s.0); Spacer(); Text(s.1).font(.caption).foregroundColor(.gray) }
                            .padding().background(Color(.systemGray6)).cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
    func box(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
