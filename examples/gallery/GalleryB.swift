// SKILL GALLERY — File B: screens 5-8 (Delivery, Sky Tonight, EV Charge, Plant)
import SwiftUI

// ===========================================================================
// SCREEN 5 — DELIVERY (Architecture A: street-grid world + journey sheet)
//   QUESTION: "where is my package right now?"  METAPHOR: watching the truck
//   turn onto your street.  TEMP: urgent-calm.  STAGE: your neighborhood.
// ===========================================================================

struct DeliveryScreen: View {
    private let parcel = Color(red: 1.00, green: 0.72, blue: 0.25)
    private let routeT: CGFloat = 0.72

    var body: some View {
        ZStack(alignment: .bottom) {
            // World: a night street grid; the route is an L through it
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                ZStack {
                    Color(red: 0.07, green: 0.08, blue: 0.11)
                    // blocks
                    Canvas { ctx, size in
                        let street = Color(red: 0.16, green: 0.18, blue: 0.24)
                        for i in 0..<7 {
                            let x = size.width * CGFloat(i) / 6.0
                            var p = Path(); p.move(to: CGPoint(x: x, y: 0))
                            p.addLine(to: CGPoint(x: x, y: size.height))
                            ctx.stroke(p, with: .color(street), lineWidth: i % 2 == 0 ? 7 : 3)
                        }
                        for i in 0..<10 {
                            let y = size.height * CGFloat(i) / 9.0
                            var p = Path(); p.move(to: CGPoint(x: 0, y: y))
                            p.addLine(to: CGPoint(x: size.width, y: y))
                            ctx.stroke(p, with: .color(street), lineWidth: i % 3 == 0 ? 7 : 3)
                        }
                        // scattered house lights
                        var state: UInt64 = 21
                        func rnd() -> CGFloat {
                            state = state &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((state >> 33) % 1000) / 1000
                        }
                        for _ in 0..<40 {
                            ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width,
                                                            y: rnd() * size.height,
                                                            width: 2.5, height: 2.5)),
                                     with: .color(Color(red: 1, green: 0.85, blue: 0.5)
                                        .opacity(0.10 + rnd() * 0.25)))
                        }
                    }

                    // the route: two legs, truck at real progress
                    deliveryRoute(w: w, h: h)
                        .stroke(.white.opacity(0.2),
                                style: StrokeStyle(lineWidth: 3, dash: [2, 7]))
                    deliveryRoute(w: w, h: h)
                        .trim(from: 0, to: routeT)
                        .stroke(parcel, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                        .shadow(color: parcel.opacity(0.8), radius: 6)

                    // home: pulsing destination
                    let home = CGPoint(x: w * 0.78, y: h * 0.30)
                    Circle().stroke(parcel.opacity(0.35), lineWidth: 1.5)
                        .frame(width: 34, height: 34).position(home)
                    Image(systemName: "house.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(parcel)
                        .position(home)

                    // the truck, on its leg
                    Image(systemName: "box.truck.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .shadow(color: parcel.opacity(0.9), radius: 6)
                        .position(deliveryPoint(w: w, h: h, t: routeT))
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            VStack {
                HStack {
                    hudChip { Text("ORDER #8412 · 1 BOX")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                    hudChip { Text("2 stops away").font(.caption.weight(.semibold))
                        .foregroundStyle(parcel) }
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 0) {
                Grabber()
                Text("Arriving 2:15–2:45 PM")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 12)
                Text("Marcus has your package — he's on Valley Circle now.")
                    .font(.callout).foregroundStyle(.secondary).padding(.top, 2)

                // journey instrument: real milestones, current one lit
                VStack(spacing: 0) {
                    journeyStep("Ordered", "Tue 6:04 PM", state: .done)
                    journeyStep("Shipped from Ontario, CA", "Thu 9:12 AM", state: .done)
                    journeyStep("Out for delivery", "Today 11:38 AM", state: .current)
                    journeyStep("Delivered", "—", state: .todo, last: true)
                }
                .padding(.top, 18)

                Button {} label: {
                    Label("Add delivery note", systemImage: "square.and.pencil")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                }
                .background(parcel, in: Capsule())
                .foregroundStyle(Color(red: 0.12, green: 0.08, blue: 0.02))
                .padding(.top, 18).padding(.bottom, 8)
            }
            .modifier(SheetSurface(fill: Color(red: 0.10, green: 0.11, blue: 0.15)))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private enum StepState { case done, current, todo }
    private func journeyStep(_ title: String, _ time: String,
                             state: StepState, last: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(state == .todo ? AnyShapeStyle(.white.opacity(0.12))
                              : AnyShapeStyle(parcel))
                        .frame(width: state == .current ? 13 : 9,
                               height: state == .current ? 13 : 9)
                        .shadow(color: state == .current ? parcel : .clear, radius: 5)
                    if state == .done {
                        Image(systemName: "checkmark")
                            .font(.system(size: 5, weight: .black))
                            .foregroundStyle(Color(red: 0.12, green: 0.08, blue: 0.02))
                    }
                }
                if !last {
                    Rectangle()
                        .fill(state == .done ? parcel.opacity(0.6) : .white.opacity(0.10))
                        .frame(width: 2, height: 26)
                }
            }
            .frame(width: 14)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.subheadline.weight(state == .current ? .bold : .medium))
                    .foregroundStyle(state == .todo ? AnyShapeStyle(.tertiary)
                                     : AnyShapeStyle(.primary))
                Text(time).font(.caption).monospacedDigit()
                    .foregroundStyle(state == .current ? AnyShapeStyle(parcel)
                                     : AnyShapeStyle(.tertiary))
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }

    private func deliveryPoint(w: CGFloat, h: CGFloat, t: CGFloat) -> CGPoint {
        // leg 1 (0-0.55): up Valley Circle; leg 2 (0.55-1): right on your street
        let start = CGPoint(x: w * 0.13, y: h * 0.86)
        let corner = CGPoint(x: w * 0.13, y: h * 0.30)
        let home = CGPoint(x: w * 0.78, y: h * 0.30)
        if t < 0.55 {
            let k = t / 0.55
            return CGPoint(x: start.x, y: start.y + (corner.y - start.y) * k)
        } else {
            let k = (t - 0.55) / 0.45
            return CGPoint(x: corner.x + (home.x - corner.x) * k, y: corner.y)
        }
    }
    private func deliveryRoute(w: CGFloat, h: CGFloat) -> Path {
        Path { p in
            p.move(to: deliveryPoint(w: w, h: h, t: 0))
            p.addLine(to: deliveryPoint(w: w, h: h, t: 0.55))
            p.addLine(to: deliveryPoint(w: w, h: h, t: 1))
        }
    }
}

// ===========================================================================
// SCREEN 6 — SKY TONIGHT (Architecture A: sky dome world + pass sheet)
//   QUESTION: "when do I look up, and where?"  METAPHOR: lying on the grass
//   facing south.  TEMP: quiet wonder.  STAGE: tonight's sky.
// ===========================================================================

struct SkyTonightScreen: View {
    private let iss = Color(red: 0.55, green: 0.85, blue: 1.0)
    private let passT: CGFloat = 0.38

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let horizonY = h * 0.62
                ZStack {
                    LinearGradient(stops: [
                        .init(color: Color(red: 0.02, green: 0.03, blue: 0.09), location: 0),
                        .init(color: Color(red: 0.06, green: 0.08, blue: 0.18), location: 0.55),
                        .init(color: Color(red: 0.12, green: 0.10, blue: 0.22), location: 1),
                    ], startPoint: .top, endPoint: .bottom)

                    // stars
                    Canvas { ctx, size in
                        var state: UInt64 = 5
                        func rnd() -> CGFloat {
                            state = state &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((state >> 33) % 1000) / 1000
                        }
                        for _ in 0..<120 {
                            let r = 0.4 + rnd() * 1.1
                            let y = rnd() * horizonY
                            ctx.fill(Path(ellipseIn: CGRect(x: rnd() * size.width, y: y,
                                                            width: r * 2, height: r * 2)),
                                     with: .color(.white.opacity(0.15 + rnd() * 0.5)))
                        }
                    }

                    // altitude arcs of the dome (30° and 60°)
                    domeArc(w: w, horizonY: horizonY, lift: 0.30)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                    domeArc(w: w, horizonY: horizonY, lift: 0.52)
                        .stroke(.white.opacity(0.08), lineWidth: 1)

                    // the ISS pass: WSW → ENE, current position lit
                    passArc(w: w, horizonY: horizonY)
                        .stroke(.white.opacity(0.25),
                                style: StrokeStyle(lineWidth: 1.5, dash: [3, 5]))
                    passArc(w: w, horizonY: horizonY)
                        .trim(from: 0, to: passT)
                        .stroke(iss, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .shadow(color: iss.opacity(0.9), radius: 6)
                    Circle().fill(.white).frame(width: 8, height: 8)
                        .shadow(color: iss, radius: 8)
                        .position(passPoint(w: w, horizonY: horizonY, t: passT))
                    Text("ISS").font(.caption2.weight(.bold)).kerning(1.2)
                        .foregroundStyle(iss)
                        .position(x: passPoint(w: w, horizonY: horizonY, t: passT).x,
                                  y: passPoint(w: w, horizonY: horizonY, t: passT).y - 16)

                    // ground silhouette + treeline
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: h))
                        p.addLine(to: CGPoint(x: 0, y: horizonY))
                        var x: CGFloat = 0
                        while x <= w {
                            p.addLine(to: CGPoint(x: x, y: horizonY - abs(sin(x / 26)) * 7))
                            x += 9
                        }
                        p.addLine(to: CGPoint(x: w, y: h))
                        p.closeSubpath()
                    }.fill(Color(red: 0.03, green: 0.04, blue: 0.06))

                    // compass pinned to the horizon — labels live IN the world
                    Text("WSW").font(.caption2.weight(.bold)).kerning(1)
                        .foregroundStyle(.white.opacity(0.5))
                        .position(x: w * 0.12, y: horizonY + 16)
                    Text("S").font(.caption2.weight(.bold)).kerning(1)
                        .foregroundStyle(.white.opacity(0.5))
                        .position(x: w * 0.5, y: horizonY + 16)
                    Text("ENE").font(.caption2.weight(.bold)).kerning(1)
                        .foregroundStyle(.white.opacity(0.5))
                        .position(x: w * 0.88, y: horizonY + 16)
                }
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)

            VStack {
                HStack {
                    hudChip { Text("TONIGHT · CLEAR SKIES")
                        .font(.caption.weight(.bold)).kerning(1.2)
                        .foregroundStyle(.white.opacity(0.85)) }
                    Spacer()
                }
                .padding(.horizontal, 20)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 0) {
                Grabber()
                Text("Look up at 9:14 PM")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 12)
                Text("A bright ISS pass — 6 minutes, brighter than any star.")
                    .font(.callout).foregroundStyle(.secondary).padding(.top, 2)

                Grid(alignment: .leading, horizontalSpacing: 26, verticalSpacing: 14) {
                    GridRow {
                        skyFact("Appears", "WSW 10°")
                        skyFact("Peak", "64° high")
                        skyFact("Fades", "ENE 12°")
                    }
                }
                .padding(.top, 20)

                Button {} label: {
                    Label("Remind me 5 minutes before", systemImage: "bell.badge.fill")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                }
                .background(iss, in: Capsule())
                .foregroundStyle(Color(red: 0.02, green: 0.08, blue: 0.14))
                .padding(.top, 20).padding(.bottom, 8)
            }
            .modifier(SheetSurface(fill: Color(red: 0.08, green: 0.09, blue: 0.15)))
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func skyFact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            microLabel(label, tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            Text(value).font(.system(.title3, design: .rounded).weight(.semibold))
                .monospacedDigit()
        }.accessibilityElement(children: .combine)
    }

    private func passPoint(w: CGFloat, horizonY: CGFloat, t: CGFloat) -> CGPoint {
        let x = w * (0.08 + 0.84 * t)
        let y = horizonY - sin(t * .pi) * horizonY * 0.66
        return CGPoint(x: x, y: y)
    }
    private func passArc(w: CGFloat, horizonY: CGFloat) -> Path {
        Path { p in
            p.move(to: passPoint(w: w, horizonY: horizonY, t: 0))
            var t: CGFloat = 0
            while t <= 1 { p.addLine(to: passPoint(w: w, horizonY: horizonY, t: t)); t += 0.02 }
        }
    }
    private func domeArc(w: CGFloat, horizonY: CGFloat, lift: CGFloat) -> Path {
        Path { p in
            p.move(to: CGPoint(x: 0, y: horizonY))
            p.addQuadCurve(to: CGPoint(x: w, y: horizonY),
                           control: CGPoint(x: w / 2, y: horizonY - horizonY * lift * 2))
        }
    }
}

// ===========================================================================
// SCREEN 7 — EV CHARGE (instrument panel: the gauge IS the screen)
//   QUESTION: "when can I leave?"  METAPHOR: a cockpit power gauge.
//   TEMP: clinical.  STAGE: none (an instrument, honestly chosen).
// ===========================================================================

struct ChargeScreen: View {
    private let volt = Color(red: 0.40, green: 0.90, blue: 0.60)
    private let level: CGFloat = 0.62

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                microLabel("Home charger · 11 kW")
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(volt).frame(width: 7, height: 7)
                    Text("Charging").font(.caption.weight(.semibold)).foregroundStyle(volt)
                }
            }
            .padding(.top, 12)

            Spacer()

            // the gauge: 270° tick ring, live arc, the answer in the middle
            ZStack {
                Canvas { ctx, size in
                    let c = CGPoint(x: size.width / 2, y: size.height / 2)
                    let r = min(size.width, size.height) / 2 - 10
                    for i in 0..<48 {
                        let frac = Double(i) / 47.0
                        let ang = (0.75 + frac * 1.5) * .pi
                        let major = i % 8 == 0
                        let inner = r - (major ? 16 : 9)
                        var p = Path()
                        p.move(to: CGPoint(x: c.x + cos(ang) * inner, y: c.y + sin(ang) * inner))
                        p.addLine(to: CGPoint(x: c.x + cos(ang) * r, y: c.y + sin(ang) * r))
                        let lit = frac <= 0.62
                        ctx.stroke(p, with: .color(lit ? Color(red: 0.40, green: 0.90, blue: 0.60)
                                                       : .white.opacity(0.12)),
                                   lineWidth: major ? 3 : 1.5)
                    }
                }
                VStack(spacing: 2) {
                    (Text("62").font(.system(size: 72, weight: .bold, design: .rounded))
                     + Text("%").font(.system(size: 34, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary))
                        .monospacedDigit()
                    Text("+38 km added").font(.footnote).monospacedDigit()
                        .foregroundStyle(volt)
                }
            }
            .frame(width: 290, height: 290)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Battery 62 percent, 38 kilometers of range added this session")

            Text("80% by 3:40 PM — in time for the school run.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 6)

            Spacer()

            // charge curve: bars taper as the battery fills — physics made visible
            VStack(alignment: .leading, spacing: 8) {
                microLabel("Charge rate this session", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                HStack(alignment: .bottom, spacing: 5) {
                    ForEach(Array([11.0, 11.0, 10.8, 10.2, 9.1, 7.6, 5.8, 4.1].enumerated()),
                            id: \.offset) { i, kw in
                        VStack(spacing: 4) {
                            Capsule()
                                .fill(i < 5 ? AnyShapeStyle(volt) : AnyShapeStyle(.white.opacity(0.15)))
                                .frame(height: kw * 6)
                        }.frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 70, alignment: .bottom)
                HStack {
                    microLabel("now", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                    Spacer()
                    microLabel("100%", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Charging at 11 kilowatts now, tapering to 4 near full")

            Button {} label: {
                Label("Stop at 80%", systemImage: "bolt.badge.checkmark.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
            }
            .background(volt, in: Capsule())
            .foregroundStyle(Color(red: 0.03, green: 0.10, blue: 0.06))
            .padding(.top, 20)
        }
        .padding(24)
        .background(Color(red: 0.05, green: 0.06, blue: 0.07).ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }
}

// ===========================================================================
// SCREEN 8 — PLANT (warm paper + drawn character-plant + care journey)
//   QUESTION: "does Fern need me today?"  METAPHOR: a botanical journal page.
//   TEMP: warm.  STAGE: the plant itself, drawn like a field-guide plate.
// ===========================================================================

struct PlantScreen: View {
    private let leaf = Color(red: 0.30, green: 0.55, blue: 0.35)
    private let terracotta = Color(red: 0.75, green: 0.44, blue: 0.30)
    private let paper = Color(red: 0.98, green: 0.97, blue: 0.93)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            microLabel("Kitchen window · Boston fern")

            Text("Fern is thirsty")
                .font(.system(size: 38, weight: .bold, design: .serif))
                .padding(.top, 6)
            Text("Last watered 6 days ago — she usually asks at 5.")
                .font(.callout).foregroundStyle(.secondary).padding(.top, 2)

            Spacer()

            // THE CHARACTER: the plant, drawn — leaves droop because she's dry
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                let potX = w / 2, potTop = h * 0.62
                ZStack {
                    // leaves: fanned, slightly drooping quad curves
                    ForEach(Array([-70, -40, -15, 15, 40, 70].enumerated()), id: \.offset) { _, deg in
                        LeafShape(droop: 0.35)
                            .fill(leaf.opacity(deg == 15 || deg == -15 ? 0.9 : 0.7))
                            .frame(width: 26, height: h * 0.42)
                            .rotationEffect(.degrees(Double(deg)), anchor: .bottom)
                            .position(x: potX, y: potTop - h * 0.21)
                    }
                    // pot
                    Path { p in
                        p.move(to: CGPoint(x: potX - 52, y: potTop))
                        p.addLine(to: CGPoint(x: potX + 52, y: potTop))
                        p.addLine(to: CGPoint(x: potX + 38, y: potTop + 74))
                        p.addLine(to: CGPoint(x: potX - 38, y: potTop + 74))
                        p.closeSubpath()
                    }.fill(terracotta)
                    Path { p in
                        p.move(to: CGPoint(x: potX - 58, y: potTop))
                        p.addLine(to: CGPoint(x: potX + 58, y: potTop))
                        p.addLine(to: CGPoint(x: potX + 58, y: potTop + 12))
                        p.addLine(to: CGPoint(x: potX - 58, y: potTop + 12))
                        p.closeSubpath()
                    }.fill(terracotta.opacity(0.85))
                }
            }
            .frame(height: 250)
            .accessibilityHidden(true)

            Spacer()

            // moisture instrument: droplet ticks at the real reading
            VStack(alignment: .leading, spacing: 8) {
                microLabel("Soil moisture", tint: AnyShapeStyle(HierarchicalShapeStyle.tertiary))
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { i in
                        Image(systemName: i < 2 ? "drop.fill" : "drop")
                            .font(.system(size: 15))
                            .foregroundStyle(i < 2 ? AnyShapeStyle(Color(red: 0.35, green: 0.60, blue: 0.85))
                                             : AnyShapeStyle(.quaternary))
                    }
                    Spacer()
                    Text("dry side")
                        .font(.caption).foregroundStyle(.tertiary)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Soil moisture 2 of 7, on the dry side")

            // care journey, phase-appropriate facts
            VStack(spacing: 0) {
                careRow("Watered", "6 days ago", done: true)
                Divider().opacity(0.3).padding(.leading, 30)
                careRow("Fed", "3 weeks ago · next in 1 week", done: true)
                Divider().opacity(0.3).padding(.leading, 30)
                careRow("Repotted", "March · roots look happy", done: true)
            }
            .padding(.top, 14)

            Button {} label: {
                Label("Water Fern now", systemImage: "drop.fill")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
            }
            .background(leaf, in: Capsule())
            .foregroundStyle(paper)
            .padding(.top, 18)
        }
        .padding(24)
        .background(paper.ignoresSafeArea())
        .foregroundStyle(Color(red: 0.18, green: 0.16, blue: 0.12))
        .preferredColorScheme(.light)
    }

    private func careRow(_ what: String, _ when: String, done: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.body)
                .foregroundStyle(done ? leaf.opacity(0.7) : Color(.systemGray3))
                .frame(width: 18)
            Text(what).font(.subheadline.weight(.medium))
            Spacer()
            Text(when).font(.caption).monospacedDigit().foregroundStyle(.tertiary)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}

struct LeafShape: Shape {
    var droop: CGFloat
    func path(in r: CGRect) -> Path {
        Path { p in
            let tipY = r.minY + r.height * droop * 0.4
            p.move(to: CGPoint(x: r.midX, y: r.maxY))
            p.addQuadCurve(to: CGPoint(x: r.midX, y: tipY),
                           control: CGPoint(x: r.minX - r.width * 0.4, y: r.midY))
            p.addQuadCurve(to: CGPoint(x: r.midX, y: r.maxY),
                           control: CGPoint(x: r.maxX + r.width * 0.4, y: r.midY))
            p.closeSubpath()
        }
    }
}
