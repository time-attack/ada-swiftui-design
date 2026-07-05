#!/bin/bash
# ADA-Grade SwiftUI Skill — eval renderer
# Builds 5 apps (before + after variants, 2 screens each) and captures REAL
# iOS Simulator screenshots: 20 PNGs total, plus a side-by-side results page.
#
# Usage:  bash run.sh
# Requires: Xcode with an iOS Simulator runtime installed.
set -euo pipefail
cd "$(dirname "$0")"

BOLD=$(tput bold 2>/dev/null || true); RESET=$(tput sgr0 2>/dev/null || true)
say() { echo "${BOLD}==> $1${RESET}"; }

# --- 1. Find a simulator ----------------------------------------------------
say "Finding an iPhone simulator"
UDID=$(xcrun simctl list devices available | grep -E "iPhone (1[5-9]|[2-9][0-9])" | grep -v "unavailable" | head -1 | grep -oE "[0-9A-F-]{36}") || true
if [ -z "${UDID:-}" ]; then
  UDID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE "[0-9A-F-]{36}") || true
fi
if [ -z "${UDID:-}" ]; then
  echo "No iPhone simulator found. Open Xcode > Settings > Components and install an iOS runtime."
  exit 1
fi
DEVNAME=$(xcrun simctl list devices | grep "$UDID" | sed -E 's/ *\(.*//' | head -1 | xargs)
say "Using: $DEVNAME ($UDID)"

# --- 2. Boot ----------------------------------------------------------------
STATE=$(xcrun simctl list devices | grep "$UDID" | grep -oE "\((Booted|Shutdown)\)" | tr -d '()')
if [ "$STATE" != "Booted" ]; then
  say "Booting simulator (headless)"
  xcrun simctl boot "$UDID"
fi
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || sleep 8
xcrun simctl status_bar "$UDID" override --time "9:41" --batteryLevel 100 --cellularBars 4 --wifiBars 3 2>/dev/null || true

# --- 3. Build & capture ------------------------------------------------------
mkdir -p build screenshots
APPS=(Drift Ember Ledger Jetline Tide Aero Tempo Vinyl Slate Calc)
# bash 3.2 (macOS default) has no associative arrays — use lookup functions
screen_name() {
  case "$1-$2" in
    Drift-1) echo home ;;       Drift-2) echo night-detail ;;
    Ember-1) echo recipe ;;     Ember-2) echo cooking ;;
    Ledger-1) echo overview ;;  Ledger-2) echo category ;;
    Jetline-1) echo board ;;    Jetline-2) echo flight ;;
    Tide-1) echo today ;;       Tide-2) echo checkin ;;
    Aero-1) echo forecast ;;
    Tempo-1) echo timer ;;
    Vinyl-1) echo player ;;
    Slate-1) echo today ;;
    Calc-1) echo calculator ;;
  esac
}
num_screens() {
  case "$1" in
    Drift|Ember|Ledger|Jetline|Tide) echo 2 ;;
    *) echo 1 ;;
  esac
}

for APP in "${APPS[@]}"; do
  LOWER=$(echo "$APP" | tr '[:upper:]' '[:lower:]')
  BUNDLE_ID="com.skilleval.$LOWER"
  APPDIR="build/$APP.app"

  say "Building $APP"
  rm -rf "$APPDIR"; mkdir -p "$APPDIR"
  cat > "$APPDIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>$APP</string>
  <key>CFBundleIdentifier</key><string>$BUNDLE_ID</string>
  <key>CFBundleName</key><string>$APP</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>UILaunchScreen</key><dict/>
  <key>UISupportedInterfaceOrientations</key><array><string>UIInterfaceOrientationPortrait</string></array>
</dict></plist>
PLIST

  xcrun -sdk iphonesimulator swiftc \
    -parse-as-library -target arm64-apple-ios17.0-simulator -O \
    -o "$APPDIR/$APP" "sources/$APP.swift"

  xcrun simctl uninstall "$UDID" "$BUNDLE_ID" 2>/dev/null || true
  xcrun simctl install "$UDID" "$APPDIR"

  for VARIANT in before after; do
    for SNUM in $(seq 1 "$(num_screens "$APP")"); do
      SNAME=$(screen_name "$APP" "$SNUM")
      OUT="screenshots/$LOWER-$SNAME-$VARIANT.png"
      if [ -f "$OUT" ]; then say "Exists, skipping $OUT (delete it to recapture)"; continue; fi
      say "Capturing $OUT"
      xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
      SIMCTL_CHILD_EVAL_VARIANT=$VARIANT SIMCTL_CHILD_EVAL_SCREEN=$SNUM \
        xcrun simctl launch "$UDID" "$BUNDLE_ID" >/dev/null
      sleep 2.5
      xcrun simctl io "$UDID" screenshot "$OUT" >/dev/null
      xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
    done
  done
done

# --- 4. Collages + README (real screenshots composited natively) -------------
say "Building collage tool"
xcrun swiftc -O -o build/collage tools/collage.swift
say "Compositing collages from real screenshots"
./build/collage screenshots collages

say "Writing README.md"
{
  echo "# ADA-Grade SwiftUI Skill — Before / After"
  echo
  echo "Ten apps. Same prompts. The only difference is the \`ada-swiftui-design\` skill."
  echo "Every image below is a **real iOS Simulator render** (iPhone, iOS 17+ SDK) —"
  echo "no mockups. \"Before\" is baseline LLM output; \"After\" is the skill applied."
  echo
  echo "![hero](collages/hero.png)"
  echo
  echo "## The pairs"
  echo
  for APP in "${APPS[@]}"; do
    LOWER=$(echo "$APP" | tr '[:upper:]' '[:lower:]')
    for SNUM in $(seq 1 "$(num_screens "$APP")"); do
      SNAME=$(screen_name "$APP" "$SNUM")
      echo "### $APP — $SNAME"
      echo
      echo "![${LOWER}-${SNAME}](collages/pair-${LOWER}-${SNAME}.png)"
      echo
    done
  done
  echo "## What changed, every time"
  echo
  echo "- One hero element per screen instead of four equal cards"
  echo "- Color only where it means something (identity, state, environment)"
  echo "- Small-caps micro-labels + huge monospaced-digit numerals"
  echo "- A real-world metaphor per app (departure board, chronograph, vinyl, day-planner)"
  echo "- Human sentences instead of database labels; zero greetings, zero emoji"
  echo "- Structural accessibility (Dynamic Type, combined stat clusters, labeled charts)"
  echo
  echo "Skill: \`SKILL.md\` · Rubric: \`EVALS.md\` · Sources: \`sources/\` · Runner: \`run.sh\`"
} > README.md

# --- 5. Results page (real screenshots, side by side) ------------------------
say "Writing RESULTS.html (side-by-side gallery of the real simulator screenshots)"
{
  echo '<html><head><meta charset="utf-8"><title>Skill eval — before vs after</title><style>'
  echo 'body{font-family:-apple-system;background:#0d0d0f;color:#eee;margin:24px}'
  echo 'h2{margin:32px 0 4px;font-size:17px} .sub{color:#888;font-size:13px;margin-bottom:10px}'
  echo '.pair{display:flex;gap:16px} .pair div{text-align:center}'
  echo 'img{width:300px;border-radius:18px;border:1px solid #333}'
  echo '.lbl{font-size:12px;color:#aaa;margin-top:6px;text-transform:uppercase;letter-spacing:1px}'
  echo '</style></head><body><h1 style="font-size:20px">ADA-Grade SwiftUI Skill — before vs after (real simulator renders)</h1>'
  for APP in "${APPS[@]}"; do
    LOWER=$(echo "$APP" | tr '[:upper:]' '[:lower:]')
    for SNUM in $(seq 1 "$(num_screens "$APP")"); do
      SNAME=$(screen_name "$APP" "$SNUM")
      echo "<h2>$APP — $SNAME</h2><div class=pair>"
      echo "<div><img src=\"screenshots/$LOWER-$SNAME-before.png\"><div class=lbl>before</div></div>"
      echo "<div><img src=\"screenshots/$LOWER-$SNAME-after.png\"><div class=lbl>after</div></div>"
      echo "</div>"
    done
  done
  echo '</body></html>'
} > RESULTS.html

say "Done. Screenshots in ./screenshots, collages in ./collages, README.md written."
open README.md 2>/dev/null || true
open RESULTS.html 2>/dev/null || true
