// BRIEF: "Build a SwiftUI screen for a parking meter timer."
// VARIANT: baseline — no design guidance.
import SwiftUI

@main
struct ParkingApp: App {
    var body: some Scene { WindowGroup { ParkingView() } }
}

struct ParkingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Parking Timer 🅿️").font(.largeTitle).bold()

            ZStack {
                Circle().stroke(Color(.systemGray5), lineWidth: 18)
                Circle().trim(from: 0, to: 0.4)
                    .stroke(LinearGradient(colors: [.purple, .blue],
                                           startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("48:12").font(.system(size: 44)).bold()
                    Text("remaining ⏳").foregroundColor(.gray)
                }
            }
            .frame(width: 220, height: 220)
            .shadow(radius: 6)

            HStack(spacing: 12) {
                infoCard("Zone", "4B", .blue)
                infoCard("Rate", "$2/hr", .green)
                infoCard("Spot", "112", .orange)
            }

            Button(action: {}) {
                Text("Add 30 Minutes ($1.00)")
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            Button(action: {}) {
                Text("End Parking Session")
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.red).foregroundColor(.white).cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
    func infoCard(_ t: String, _ v: String, _ c: Color) -> some View {
        VStack { Text(t).font(.caption); Text(v).font(.headline).foregroundColor(c) }
            .frame(maxWidth: .infinity).padding().background(c.opacity(0.15)).cornerRadius(12)
    }
}
