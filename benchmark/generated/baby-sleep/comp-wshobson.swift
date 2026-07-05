// BRIEF: "Build a SwiftUI screen for a baby sleep log."
// VARIANT: comp-wshobson (HIG semantic-first, SF Symbols, cards, a11y)
import SwiftUI

@main
struct BabyApp: App {
    var body: some Scene { WindowGroup { SleepLogView() } }
}

struct SleepLogView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "moon.stars.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.indigo)
                            .frame(width: 60, height: 60)
                            .background(.indigo.opacity(0.1), in: Circle())
                        Text("11h 20m").font(.largeTitle.bold()).monospacedDigit()
                        Text("Total sleep today · 3 naps + night sleep")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("11 hours 20 minutes total sleep today")

                    ForEach([("moon.fill", "Night sleep", "8:10 PM – 4:55 AM", "8h 45m"),
                             ("zzz", "Nap 1", "8:30 – 9:25 AM", "55 min"),
                             ("zzz", "Nap 2", "12:10 – 1:05 PM", "55 min"),
                             ("zzz", "Nap 3", "3:40 – 4:25 PM", "45 min")], id: \.2) { s in
                        HStack(spacing: 16) {
                            Image(systemName: s.0)
                                .font(.title3)
                                .foregroundStyle(.indigo)
                                .frame(width: 44, height: 44)
                                .background(.indigo.opacity(0.1), in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(s.1).font(.headline)
                                Text(s.2).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(s.3)
                                .font(.subheadline.weight(.semibold))
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .accessibilityElement(children: .combine)
                    }

                    Button {} label: {
                        Label("Start Sleep Timer", systemImage: "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Sleep Log")
        }
    }
}
