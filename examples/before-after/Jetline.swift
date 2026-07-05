// EVAL APP 4 — "Jetline", a flight tracker. Screens: departures board, flight detail.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: board → "which of my flights needs attention?"  detail → "is it on time?"
//   METAPHOR: airport signage; the detail screen is the night sky over the Pacific.
//   TEMPERATURE: urgent-calm.
//   STAGE: the flight HAS a place — somewhere over an ocean. So the detail screen
//   is architecture A: an immersive full-bleed world (night hemisphere, star field,
//   the route arcing across it) with the data floating above it on a bottom sheet.
//   The globe is cropped by the camera, not shrunk into a box.
import SwiftUI

@main
struct JetlineApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        let screen = (args.contains("--screen2") || env["EVAL_SCREEN"] == "2") ? 2 : 1
        return Group {
            if after {
                if screen == 1 { A_Board() } else { A_FlightDetail() }
            } else {
                if screen == 1 { B_Board() } else { B_FlightDetail() }
            }
        }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Board: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("My Flights ✈️").font(.largeTitle).bold()

                ForEach([("UA 1847", "LAX → SFO", "On Time ✅", Color.green),
                         ("BR 12", "KIX → TPE", "Delayed ⚠️", Color.orange),
                         ("AA 204", "JFK → LAX", "On Time ✅", Color.green)], id: \.0) { f in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.blue, .cyan],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 110)
                        .overlay(
                            VStack(spacing: 6) {
                                Text("✈️ " + f.0).font(.headline).foregroundColor(.white)
                                Text(f.1).foregroundColor(.white.opacity(0.9))
                                Text(f.2).font(.caption).padding(6)
                                    .background(f.3.opacity(0.9)).foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        )
                        .shadow(radius: 5)
                }

                Button(action: {}) {
                    Text("+ Track New Flight")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct B_FlightDetail: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Flight UA 1847 ✈️").font(.title).bold()

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray4))
                    .frame(height: 160)
                    .overlay(Text("🗺️ Map View").font(.title2))

                ProgressView(value: 0.65)
                    .padding(.horizontal)
                Text("65% Complete").font(.caption).foregroundColor(.gray)

                HStack(spacing: 12) {
                    B_InfoCard(title: "Gate", value: "42B", color: .blue)
                    B_InfoCard(title: "Seat", value: "14A", color: .green)
                    B_InfoCard(title: "Terminal", value: "7", color: .purple)
                }
                HStack(spacing: 12) {
                    B_InfoCard(title: "Departs", value: "2:15 PM", color: .orange)
                    B_InfoCard(title: "Arrives", value: "4:52 PM", color: .red)
                    B_InfoCard(title: "Duration", value: "2h 37m", color: .teal)
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
}

struct B_InfoCard: View {
    let title: String, value: String
    let color: Color
    var body: some View {
        VStack {
            Text(title).font(.caption)
            Text(value).font(.headline).foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding()
        .background(color.opacity(0.15)).cornerRadius(12)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

private let tarmac = Color(red: 0.04, green: 0.05, blue: 0.09)
private let sheetFill = Color(red: 0.10, green: 0.11, blue: 0.16)

enum A_Status {
    case onTime, delayed, boarding, enRoute, landed
    var hue: Color {
        switch self {
        case .onTime: Color(red: 0.30, green: 0.85, blue: 0.55)
        case .delayed: Color(red: 1.00, green: 0.72, blue: 0.25)
        case .boarding, .enRoute: Color(red: 0.40, green: 0.70, blue: 1.00)
        case .landed: Color(white: 0.62)
        }
    }
    var label: String {
        switch self {
        case .onTime: "On time"
        case .delayed: "Delayed 45m"
        case .boarding: "Boarding"
        case .enRoute: "In flight"
        case .landed: "Landed"
        }
    }
}

struct A_Flight: Identifiable {
    let id = UUID()
    let number: String, from: String, fromCity: String, to: String, toCity: String
    let time: String, suffix: String
    let status: A_Status
    let progress: CGFloat        // real journey position drives each row's instrument
    let detail: String           // the one fact this flight wants you to know now
    static let all = [
        A_Flight(number: "BR 12", from: "TPE", fromCity: "Taipei", to: "LAX", toCity: "Los Angeles",
                 time: "9:40", suffix: "AM", status: .delayed, progress: 0,
                 detail: "Gate B4 · boards 8:55 AM"),
        A_Flight(number: "UA 1847", from: "LAX", fromCity: "Los Angeles", to: "SFO", toCity: "San Francisco",
                 time: "2:15", suffix: "AM", status: .enRoute, progress: 0.42,
                 detail: "Lands 3:28 AM · 26m left"),
        A_Flight(number: "AA 204", from: "JFK", fromCity: "New York", to: "LAX", toCity: "Los Angeles",
                 time: "6:05", suffix: "AM", status: .landed, progress: 1.0,
                 detail: "Arrived 9:12 AM · bags at carousel 4"),
    ]
}

struct A_Board: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Departures")
                .font(.subheadline.smallCaps().weight(.medium))
                .kerning(1.6)
                .foregroundStyle(.secondary)
            Text("Saturday, July 5")
                .font(.title2.weight(.bold))
                .padding(.top, 2)

            // The flight needing attention gets a real surface, not a floating line
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.subheadline)
                    .foregroundStyle(A_Status.delayed.hue)
                VStack(alignment: .leading, spacing: 1) {
                    Text("BR 12 is delayed 45 minutes")
                        .font(.footnote.weight(.semibold))
                    Text("New departure 9:40 AM · gate B4 unchanged")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(A_Status.delayed.hue.opacity(0.10),
                        in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(A_Status.delayed.hue.opacity(0.30), lineWidth: 1))
            .padding(.top, 14)
            .accessibilityElement(children: .combine)

            Spacer().frame(height: 10)

            // Board rows: each flight is a journey, so each row carries its own
            // live route instrument — the plane sits where the flight actually is.
            VStack(spacing: 0) {
                ForEach(A_Flight.all) { f in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(f.number)
                                .font(.system(.title3, design: .monospaced).weight(.bold))
                            HStack(spacing: 5) {
                                Circle().fill(f.status.hue).frame(width: 6, height: 6)
                                Text(f.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(f.status.hue)
                            }
                            .padding(.leading, 6)
                            Spacer()
                            (Text(f.time).font(.system(.title3, design: .rounded).weight(.bold))
                             + Text(" \(f.suffix)").font(.caption.weight(.medium)).foregroundStyle(.secondary))
                                .monospacedDigit()
                                .foregroundStyle(f.status == .delayed ? A_Status.delayed.hue : .white)
                        }

                        // The mini world: origin ───✈─── destination at real progress
                        HStack(spacing: 12) {
                            cityBlock(code: f.from, city: f.fromCity, alignment: .leading)
                            GeometryReader { geo in
                                let x = geo.size.width * f.progress
                                ZStack(alignment: .leading) {
                                    Capsule().fill(.white.opacity(0.10)).frame(height: 3)
                                    if f.progress > 0 {
                                        Capsule()
                                            .fill(LinearGradient(
                                                colors: [f.status.hue.opacity(0.2), f.status.hue],
                                                startPoint: .leading, endPoint: .trailing))
                                            .frame(width: max(6, x), height: 3)
                                            .shadow(color: f.status.hue.opacity(0.7), radius: 4)
                                    }
                                    if f.progress >= 1 {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(f.status.hue)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } else {
                                        Image(systemName: "airplane")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(f.progress > 0 ? .white : f.status.hue)
                                            .shadow(color: f.status.hue.opacity(0.8), radius: 4)
                                            .offset(x: min(max(x - 6, 0), geo.size.width - 13))
                                    }
                                }
                                .frame(maxHeight: .infinity, alignment: .center)
                            }
                            .frame(height: 18)
                            cityBlock(code: f.to, city: f.toCity, alignment: .trailing)
                        }

                        // One useful fact per flight, phase-appropriate
                        Text(f.detail)
                            .font(.caption)
                            .monospacedDigit()
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 15)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(f.number), \(f.fromCity) to \(f.toCity), \(f.time) \(f.suffix), \(f.status.label), \(f.detail)")

                    if f.id != A_Flight.all.last?.id {
                        Divider().opacity(0.35)
                    }
                }
            }

            Spacer(minLength: 12)

            // Quiet summary + CTA pinned to the bottom edge where thumbs live
            Text("3 flights tracked · 1 needs attention")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)

            Button {} label: {
                Label("Track a flight", systemImage: "plus")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(.white, in: Capsule())
            .foregroundStyle(tarmac)
        }
        .padding(24)
        .background(tarmac.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func cityBlock(code: String, city: String, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(code).font(.subheadline.weight(.bold)).kerning(0.5)
            Text(city).font(.caption2).foregroundStyle(.tertiary)
        }
        .frame(width: 78, alignment: alignment == .leading ? .leading : .trailing)
    }
}

// THE WORLD — the night hemisphere the flight is actually crossing, full-bleed.
// The globe is huge and cropped by the screen (a camera angle, not clip-art);
// both endpoints sit ON the sphere and the route bends over it.
struct A_World: View {
    let accent: Color
    let progress: CGFloat

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let center = CGPoint(x: w * 0.50, y: h * 0.46)
            let r = w * 0.78                       // bigger than the screen: cropped shot
            let a = CGPoint(x: center.x - r * 0.60, y: center.y + r * 0.33)  // TPE, on sphere
            let b = CGPoint(x: center.x + r * 0.63, y: center.y - r * 0.22)  // LAX, on sphere
            let c = CGPoint(x: (a.x + b.x) / 2, y: min(a.y, b.y) - r * 0.42) // altitude
            let t = progress
            let planeX = (1-t)*(1-t)*a.x + 2*(1-t)*t*c.x + t*t*b.x
            let planeY = (1-t)*(1-t)*a.y + 2*(1-t)*t*c.y + t*t*b.y
            let dx = 2*(1-t)*(c.x-a.x) + 2*t*(b.x-c.x)
            let dy = 2*(1-t)*(c.y-a.y) + 2*t*(b.y-c.y)

            ZStack {
                // seeded star field across the whole sky
                Canvas { ctx, size in
                    var state: UInt64 = 9
                    func rnd() -> CGFloat {
                        state = state &* 6364136223846793005 &+ 1442695040888963407
                        return CGFloat((state >> 33) % 1000) / 1000
                    }
                    for _ in 0..<110 {
                        let sr = 0.4 + rnd() * 1.2
                        ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width,
                                                        y: rnd() * size.height,
                                                        width: sr * 2, height: sr * 2)),
                                 with: .color(.white.opacity(0.12 + rnd() * 0.45)))
                    }
                }

                // the hemisphere, lit from the route's side
                ZStack {
                    Circle().fill(RadialGradient(
                        colors: [Color(red: 0.15, green: 0.22, blue: 0.40),
                                 Color(red: 0.05, green: 0.08, blue: 0.16)],
                        center: UnitPoint(x: 0.38, y: 0.28),
                        startRadius: r * 0.10, endRadius: r * 1.15))
                    ForEach([1.0, 0.74, 0.48, 0.20], id: \.self) { f in
                        Ellipse()
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                            .frame(width: 2 * r * f, height: 2 * r)
                    }
                    ForEach([-0.5, -0.25, 0.0, 0.25, 0.5], id: \.self) { lat in
                        let lw = 2 * r * sqrt(max(0.001, 1 - lat * lat))
                        Ellipse()
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                            .frame(width: lw, height: lw * 0.20)
                            .offset(y: r * lat)
                    }
                    Circle().stroke(.white.opacity(0.16), lineWidth: 1)
                }
                .frame(width: 2 * r, height: 2 * r)
                .position(center)

                // atmosphere rim
                Circle()
                    .stroke(accent.opacity(0.16), lineWidth: 10)
                    .blur(radius: 14)
                    .frame(width: 2 * r, height: 2 * r)
                    .position(center)

                // the route: dashed plan + glowing flown arc, bending over the sphere
                Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
                    .stroke(.white.opacity(0.28),
                            style: StrokeStyle(lineWidth: 1.5, dash: [3, 5]))
                Path { p in p.move(to: a); p.addQuadCurve(to: b, control: c) }
                    .trim(from: 0, to: t)
                    .stroke(accent, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .shadow(color: accent.opacity(0.9), radius: 5)

                // endpoints pinned IN the world
                Circle().fill(.white).frame(width: 7, height: 7).position(a)
                Circle().stroke(accent, lineWidth: 2).frame(width: 11, height: 11).position(b)
                Text("TPE").font(.caption2.weight(.bold)).kerning(1.2)
                    .foregroundStyle(.white.opacity(0.65))
                    .position(x: a.x + 2, y: a.y + 18)
                Text("LAX").font(.caption2.weight(.bold)).kerning(1.2)
                    .foregroundStyle(accent)
                    .position(x: b.x - 2, y: b.y - 17)

                // the plane, on course, tangent to the arc
                Image(systemName: "airplane")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: accent.opacity(0.9), radius: 7)
                    .rotationEffect(.radians(Double(atan2(dy, dx))))
                    .position(x: planeX, y: planeY)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Night route map: 65 percent of the way from Taipei to Los Angeles")
    }
}

struct A_FlightDetail: View {
    private let progress: CGFloat = 0.65
    private let hue = A_Status.onTime.hue

    var body: some View {
        ZStack(alignment: .bottom) {
            // LAYER 1 — the world, edge to edge. No box, no frame, no caption.
            A_World(accent: hue, progress: progress)
                .background(tarmac)
                .ignoresSafeArea()

            // LAYER 2a — HUD chips floating in the world's top corners
            VStack {
                HStack {
                    hudChip { Text("BR 12 · EVA AIR")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    hudChip {
                        HStack(spacing: 5) {
                            Circle().fill(hue).frame(width: 7, height: 7)
                            Text("On time").font(.caption.weight(.semibold)).foregroundStyle(hue)
                        }
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            // LAYER 2b — the sheet: every fact lives on this surface, not in the sky
            VStack(alignment: .leading, spacing: 0) {
                Capsule().fill(.white.opacity(0.25))
                    .frame(width: 36, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                Text("Lands 4:52 PM")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 14)
                Text("4h 06m remaining · over the Pacific")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)

                // The instrument: endpoints, times, glowing trail, plane at 65%
                VStack(spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("TPE").font(.title3.weight(.bold))
                            Text("9:40 AM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("11h 45m")
                            .font(.caption.smallCaps().weight(.medium))
                            .kerning(1.0)
                            .monospacedDigit()
                            .foregroundStyle(.tertiary)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 1) {
                            Text("LAX").font(.title3.weight(.bold))
                            Text("4:52 PM").font(.caption).monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                    GeometryReader { geo in
                        let x = geo.size.width * progress
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.10)).frame(height: 5)
                            Capsule()
                                .fill(LinearGradient(colors: [hue.opacity(0.25), hue],
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(width: x, height: 5)
                                .shadow(color: hue.opacity(0.8), radius: 5)
                            Circle().stroke(.white.opacity(0.35), lineWidth: 1.5)
                                .frame(width: 9, height: 9)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Image(systemName: "airplane")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .shadow(color: hue.opacity(0.9), radius: 5)
                                .offset(x: x - 7)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 20)
                }
                .padding(.top, 22)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Taipei 9:40 AM to Los Angeles 4:52 PM, 65 percent flown, 4 hours 6 minutes remaining")

                // Facts grid, inside the surface
                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 16) {
                    GridRow {
                        boardFact("Gate", "42B")
                        boardFact("Terminal", "7")
                        boardFact("Seat", "14A")
                    }
                    GridRow {
                        boardFact("Aircraft", "77W")
                        boardFact("Boarded", "9:05 AM")
                        boardFact("Baggage", "4")
                    }
                }
                .padding(.top, 22)

                Button {} label: {
                    Label("Share arrival time", systemImage: "square.and.arrow.up")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }
                .background(.white, in: Capsule())
                .foregroundStyle(tarmac)
                .padding(.top, 22)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                    .fill(sheetFill)
                    .overlay(
                        UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.55), radius: 24, y: -10)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func hudChip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.black.opacity(0.35), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.12), lineWidth: 1))
    }

    private func boardFact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption.smallCaps())
                .kerning(1.0)
                .foregroundStyle(.tertiary)
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}
