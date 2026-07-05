// EVAL APP 10 — "Calc", a calculator. Screen: main.
// Variants: --before / --after
//
// AFTER design notes (Step 0):
//   QUESTION: "what's the number?" (display is the hero, keys are the machine)
//   METAPHOR: a desktop financial calculator — matte keys, one amber operator column.
//   TEMPERATURE: clinical.
import SwiftUI

@main
struct CalcApp: App {
    var body: some Scene { WindowGroup { EvalRoot() } }
}

struct EvalRoot: View {
    var body: some View {
        let args = ProcessInfo.processInfo.arguments
        let env = ProcessInfo.processInfo.environment
        let after = args.contains("--after") || env["EVAL_VARIANT"] == "after"
        return Group { if after { A_Calc() } else { B_Calc() } }
    }
}

// ===========================================================================
// BEFORE
// ===========================================================================

struct B_Calc: View {
    let keys = [["7", "8", "9", "÷"], ["4", "5", "6", "×"],
                ["1", "2", "3", "-"], ["C", "0", "=", "+"]]

    var body: some View {
        VStack(spacing: 16) {
            Text("Calculator 🧮").font(.largeTitle).bold()

            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.purple, .blue],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 110)
                .overlay(
                    Text("1284.5")
                        .font(.system(size: 44)).bold()
                        .foregroundColor(.white)
                )
                .shadow(radius: 8)
                .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(keys, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(row, id: \.self) { k in
                            Button(k) {}
                                .font(.title2)
                                .frame(maxWidth: .infinity, minHeight: 64)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
    }
}

// ===========================================================================
// AFTER
// ===========================================================================

struct A_Calc: View {
    private let amber = Color(red: 1.00, green: 0.62, blue: 0.20)
    private let panel = Color(red: 0.06, green: 0.06, blue: 0.08)
    private let keyFace = Color(red: 0.13, green: 0.13, blue: 0.16)

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Display: the running expression stays visible but quiet;
            // the result is the hero, right-aligned like every calculator since 1972.
            VStack(alignment: .trailing, spacing: 6) {
                Text("1,175 + 109.50")
                    .font(.system(.title3, design: .rounded).weight(.medium))
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
                Text("1,284.50")
                    .font(.system(size: 76, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .contentTransition(.numericText())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 28)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("1,175 plus 109.50 equals 1,284.50")

            Spacer().frame(height: 28)

            // Keys: digits matte, functions quiet, operators one amber column —
            // three roles, three treatments, zero rainbow.
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    fnKey("AC"); fnKey("±"); fnKey("%"); opKey("÷")
                }
                GridRow {
                    numKey("7"); numKey("8"); numKey("9"); opKey("×")
                }
                GridRow {
                    numKey("4"); numKey("5"); numKey("6"); opKey("−")
                }
                GridRow {
                    numKey("1"); numKey("2"); numKey("3"); opKey("+")
                }
                GridRow {
                    numKey("0").gridCellColumns(2)
                    numKey(".")
                    eqKey()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(panel.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
    }

    private func numKey(_ label: String) -> some View {
        Button {} label: {
            Text(label)
                .font(.system(.title, design: .rounded).weight(.medium))
                .monospacedDigit()
                .frame(maxWidth: .infinity, minHeight: 76)
        }
        .background(keyFace, in: RoundedRectangle(cornerRadius: 20))
        .foregroundStyle(.white)
    }

    private func fnKey(_ label: String) -> some View {
        Button {} label: {
            Text(label)
                .font(.system(.title2, design: .rounded).weight(.medium))
                .frame(maxWidth: .infinity, minHeight: 76)
        }
        .background(keyFace.opacity(0.55), in: RoundedRectangle(cornerRadius: 20))
        .foregroundStyle(.secondary)
    }

    private func opKey(_ label: String) -> some View {
        Button {} label: {
            Text(label)
                .font(.system(.title, design: .rounded).weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 76)
        }
        .background(amber.opacity(0.16), in: RoundedRectangle(cornerRadius: 20))
        .foregroundStyle(amber)
    }

    private func eqKey() -> some View {
        Button {} label: {
            Text("=")
                .font(.system(.title, design: .rounded).weight(.bold))
                .frame(maxWidth: .infinity, minHeight: 76)
        }
        .background(amber, in: RoundedRectangle(cornerRadius: 20))
        .foregroundStyle(panel)
    }
}
