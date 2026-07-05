// BRIEF: "Build a SwiftUI screen for a podcast player."
// VARIANT: ada — skill applied.
// QUESTION: "where am I in this conversation, and what's coming?"
// METAPHOR: a radio studio console in a dim room — the waveform IS the episode.
// TEMPERATURE: warm-calm.  STAGE: the spoken word itself (instrument).
import SwiftUI

@main
struct PodcastApp: App {
    var body: some Scene { WindowGroup { PlayerView() } }
}

struct PlayerView: View {
    private let amber = Color(red: 0.95, green: 0.65, blue: 0.30)
    private let progress: CGFloat = 0.35
    private let chapters: [CGFloat] = [0, 0.18, 0.42, 0.71, 0.9]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tech Talk Weekly · Ep. 214")
                .font(.subheadline.smallCaps().weight(.medium))
                .kerning(1.2)
                .foregroundStyle(.secondary)
                .padding(.top, 12)

            Text("The Future of AI")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .padding(.top, 6)

            Text("Chapter 2 of 5 — \"Agents that actually ship\"")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 4)

            Spacer()

            // THE INSTRUMENT: the episode's waveform, drawn — played side lit amber,
            // chapter boundaries as taller marks, the needle where you are.
            VStack(spacing: 10) {
                Canvas { ctx, size in
                    var state: UInt64 = 31
                    func rnd() -> CGFloat {
                        state = state &* 6364136223846793005 &+ 1442695040888963407
                        return CGFloat((state >> 33) % 1000) / 1000
                    }
                    let n = 64
                    let bw = size.width / CGFloat(n)
                    for i in 0..<n {
                        let f = CGFloat(i) / CGFloat(n - 1)
                        let isChapter = chapters.contains { abs($0 - f) < 0.008 }
                        let hgt = isChapter ? size.height * 0.95
                                            : size.height * (0.25 + rnd() * 0.6)
                        let x = CGFloat(i) * bw + bw * 0.25
                        let rect = CGRect(x: x, y: (size.height - hgt) / 2,
                                          width: bw * 0.5, height: hgt)
                        let played = f <= 0.35
                        ctx.fill(Path(roundedRect: rect, cornerSize: CGSize(width: bw * 0.25,
                                      height: bw * 0.25)),
                                 with: .color(played ? Color(red: 0.95, green: 0.65, blue: 0.30)
                                                     : .white.opacity(isChapter ? 0.45 : 0.18)))
                    }
                    // needle
                    let nx = size.width * 0.35
                    var needle = Path()
                    needle.move(to: CGPoint(x: nx, y: 0))
                    needle.addLine(to: CGPoint(x: nx, y: size.height))
                    ctx.stroke(needle, with: .color(.white), lineWidth: 2)
                }
                .frame(height: 88)

                HStack {
                    Text("18:22").font(.footnote.weight(.medium)).monospacedDigit()
                        .foregroundStyle(amber)
                    Spacer()
                    Text("-33:48").font(.footnote).monospacedDigit()
                        .foregroundStyle(.tertiary)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("18 minutes 22 in, 33 minutes 48 left, chapter 2 of 5")

            Spacer()

            // Chapters: the now gets full contrast, the rest recede (Rule 6)
            VStack(spacing: 0) {
                chapterRow("The hype correction", "0:00", state: .past)
                chapterRow("Agents that actually ship", "9:41", state: .now)
                chapterRow("Chips, power, and cost", "22:04", state: .future)
                chapterRow("Listener questions", "37:15", state: .future)
            }

            Spacer()

            // One loud thing in the room: play/pause
            HStack(spacing: 44) {
                Button {} label: {
                    Image(systemName: "gobackward.15")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Back 15 seconds")
                Button {} label: {
                    Image(systemName: "pause.fill")
                        .font(.title)
                        .frame(width: 72, height: 72)
                        .background(amber, in: Circle())
                        .foregroundStyle(Color(red: 0.12, green: 0.07, blue: 0.03))
                }
                .accessibilityLabel("Pause")
                Button {} label: {
                    Image(systemName: "goforward.30")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Forward 30 seconds")
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
        }
        .padding(24)
        .background(
            LinearGradient(stops: [
                .init(color: Color(red: 0.10, green: 0.07, blue: 0.06), location: 0),
                .init(color: Color(red: 0.06, green: 0.05, blue: 0.05), location: 1),
            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private enum ChapterState { case past, now, future }
    private func chapterRow(_ title: String, _ time: String, state: ChapterState) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(state == .now ? AnyShapeStyle(amber) : AnyShapeStyle(.quaternary))
                .frame(width: 7, height: 7)
            Text(title)
                .font(state == .now ? .body.weight(.semibold) : .body)
                .foregroundStyle(state == .now ? AnyShapeStyle(.primary)
                                 : state == .past ? AnyShapeStyle(.quaternary)
                                 : AnyShapeStyle(.tertiary))
            Spacer()
            Text(time)
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(state == .now ? AnyShapeStyle(amber) : AnyShapeStyle(.tertiary))
        }
        .padding(.vertical, 9)
        .accessibilityElement(children: .combine)
    }
}
