// BRIEF: "Build a SwiftUI screen for a workout rest timer."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, Gauge, cards)
import SwiftUI

@main
struct RestApp: App {
    var body: some Scene { WindowGroup { RestView() } }
}

struct RestView: View {
    @State private var secondsLeft = 49

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Gauge(value: Double(secondsLeft), in: 0...90) {
                            EmptyView()
                        } currentValueLabel: {
                            Text("0:49").monospacedDigit()
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .scaleEffect(2.2)
                        .frame(height: 160)
                        .tint(.green)
                        Text("Rest remaining")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("49 seconds of rest remaining")

                    HStack(spacing: 16) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.title3)
                            .foregroundStyle(.blue)
                            .frame(width: 44, height: 44)
                            .background(.blue.opacity(0.1), in: Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Squats — Set 3 of 5").font(.headline)
                            Text("185 lb · last set felt strong").font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.background, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    .accessibilityElement(children: .combine)

                    HStack(spacing: 12) {
                        Button { secondsLeft = max(0, secondsLeft - 15) } label: {
                            Label("15s", systemImage: "minus")
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                        }
                        .buttonStyle(.bordered)
                        Button { secondsLeft += 15 } label: {
                            Label("15s", systemImage: "plus")
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                        }
                        .buttonStyle(.bordered)
                    }

                    Button { secondsLeft = 0 } label: {
                        Label("Skip Rest", systemImage: "forward.end.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Rest Timer")
        }
    }
}
