// BRIEF: "Build a SwiftUI screen for a pomodoro focus session."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, cards, a11y)
import SwiftUI

@main
struct PomodoroApp: App {
    var body: some Scene { WindowGroup { PomodoroView() } }
}

struct PomodoroView: View {
    @State private var isRunning = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "timer")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                            .frame(width: 60, height: 60)
                            .background(.red.opacity(0.1), in: Circle())
                        Text("17:03")
                            .font(.system(size: 54, weight: .bold))
                            .monospacedDigit()
                        Text("Focus session 2 of 4")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Gauge(value: 0.32) { EmptyView() }
                            .gaugeStyle(.linearCapacity)
                            .tint(.red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("17 minutes 3 seconds remaining, session 2 of 4")

                    ForEach([("pencil.and.outline", "Current task", "Write essay outline"),
                             ("cup.and.saucer.fill", "Next break", "5 minutes at 2:45 PM"),
                             ("checkmark.circle.fill", "Completed today", "2 focus blocks")], id: \.1) { row in
                        HStack(spacing: 16) {
                            Image(systemName: row.0)
                                .font(.title3)
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.red.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.1).font(.headline)
                                Text(row.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {
                        isRunning.toggle()
                    } label: {
                        Label(isRunning ? "Pause" : "Resume",
                              systemImage: isRunning ? "pause.fill" : "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Button(role: .destructive) {} label: {
                        Text("End Session")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pomodoro")
        }
    }
}
