// BRIEF: "Build a SwiftUI screen for a flight tracker."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct FlightApp: App {
    var body: some Scene { WindowGroup { FlightView() } }
}

struct FlightView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Flight Tracker ✈️").font(.title).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray4))
                    .frame(height: 160)
                    .overlay(Text("🗺️ Map View").font(.title2))

                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.blue, .cyan],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 110)
                    .overlay(VStack(spacing: 6) {
                        Text("✈️ BR 12 - EVA Air").font(.headline).foregroundColor(.white)
                        Text("TPE → LAX").foregroundColor(.white.opacity(0.9))
                        Text("On Time ✅").font(.caption).padding(6)
                            .background(Color.green.opacity(0.9)).foregroundColor(.white)
                            .cornerRadius(8)
                    })
                    .shadow(radius: 5)

                ProgressView(value: 0.65).padding(.horizontal)
                Text("65% Complete").font(.caption).foregroundColor(.gray)

                HStack(spacing: 12) {
                    card("Gate", "42B", .blue)
                    card("Seat", "14A", .green)
                    card("Terminal", "7", .purple)
                }
                HStack(spacing: 12) {
                    card("Departs", "9:40 AM", .orange)
                    card("Arrives", "4:52 PM", .red)
                    card("Duration", "11h 45m", .teal)
                }

                HStack {
                    Button("Share Flight") {}
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.gray).foregroundColor(.white).cornerRadius(10)
                    Button("Get Updates") {}
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
    func card(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
