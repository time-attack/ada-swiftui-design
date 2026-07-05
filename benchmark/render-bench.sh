#!/bin/bash
# Benchmark renderer — builds all 50 generated apps (10 briefs x 5 variants)
# and captures a real simulator screenshot of each.
# Usage: bash render-bench.sh
set -euo pipefail
cd "$(dirname "$0")"

BOLD=$(tput bold 2>/dev/null || true); RESET=$(tput sgr0 2>/dev/null || true)
say() { echo "${BOLD}==> $1${RESET}"; }

say "Finding an iPhone simulator"
UDID=$(xcrun simctl list devices available | grep -E "iPhone (1[5-9]|[2-9][0-9])" | grep -v "unavailable" | head -1 | grep -oE "[0-9A-F-]{36}") || true
if [ -z "${UDID:-}" ]; then
  UDID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE "[0-9A-F-]{36}") || true
fi
[ -z "${UDID:-}" ] && { echo "No iPhone simulator found."; exit 1; }
STATE=$(xcrun simctl list devices | grep "$UDID" | grep -oE "\((Booted|Shutdown)\)" | tr -d '()')
if [ "$STATE" != "Booted" ]; then
  say "Booting simulator (headless)"
  xcrun simctl boot "$UDID"
fi
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || sleep 8
xcrun simctl status_bar "$UDID" override --time "9:41" --batteryLevel 100 --cellularBars 4 --wifiBars 3 2>/dev/null || true

mkdir -p build screenshots
PASS=0; FAILED=0; FAILED_LIST=""

for SRC in generated/*/*.swift; do
  BRIEF=$(basename "$(dirname "$SRC")")
  VARIANT=$(basename "$SRC" .swift)
  NAME="$BRIEF-$VARIANT"
  OUT="screenshots/$NAME.png"
  if [ -f "$OUT" ]; then say "Exists, skipping $OUT"; PASS=$((PASS+1)); continue; fi

  SAFE=$(echo "$NAME" | tr -cd 'a-z0-9')
  BUNDLE_ID="com.bench.$SAFE"
  APPDIR="build/$NAME.app"
  rm -rf "$APPDIR"; mkdir -p "$APPDIR"
  cat > "$APPDIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>bench</string>
  <key>CFBundleIdentifier</key><string>$BUNDLE_ID</string>
  <key>CFBundleName</key><string>$NAME</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>UILaunchScreen</key><dict/>
  <key>UISupportedInterfaceOrientations</key><array><string>UIInterfaceOrientationPortrait</string></array>
</dict></plist>
PLIST

  say "Building $NAME"
  if ! xcrun -sdk iphonesimulator swiftc \
      -parse-as-library -target arm64-apple-ios17.0-simulator -O \
      -o "$APPDIR/bench" "$SRC" 2> "build/$NAME.log"; then
    echo "  COMPILE FAILED (see build/$NAME.log)"
    FAILED=$((FAILED+1)); FAILED_LIST="$FAILED_LIST $NAME"
    continue
  fi

  xcrun simctl uninstall "$UDID" "$BUNDLE_ID" 2>/dev/null || true
  xcrun simctl install "$UDID" "$APPDIR"
  xcrun simctl launch "$UDID" "$BUNDLE_ID" >/dev/null
  sleep 2.2
  xcrun simctl io "$UDID" screenshot "$OUT" >/dev/null
  xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
  PASS=$((PASS+1))
done

say "Done: $PASS rendered, $FAILED compile failures.${FAILED_LIST:+ Failed:$FAILED_LIST}"

# --- results page: 5 variants side by side per brief --------------------------
say "Writing RESULTS.html"
{
  echo '<html><head><meta charset="utf-8"><title>Skill benchmark — 10 briefs x 5 variants</title><style>'
  echo 'body{font-family:-apple-system;background:#0d0d0f;color:#eee;margin:24px}'
  echo 'h2{margin:30px 0 8px;font-size:16px}'
  echo '.row{display:grid;grid-template-columns:repeat(5,1fr);gap:10px}'
  echo '.row div{text-align:center} img{width:100%;border-radius:12px;border:1px solid #333}'
  echo '.lbl{font-size:11px;color:#aaa;margin-top:4px;text-transform:uppercase;letter-spacing:1px}'
  echo '.lbl.ada{color:#4ed98c}'
  echo '</style></head><body><h1 style="font-size:20px">SwiftUI design skill benchmark</h1>'
  echo '<div style="color:#888;font-size:13px">baseline = no guidance · three real competitor skills · ada = this repo. Real simulator renders.</div>'
  for D in generated/*/; do
    BRIEF=$(basename "$D")
    echo "<h2>$BRIEF</h2><div class=row>"
    for V in baseline comp-trilliwon comp-harperhhh comp-wshobson ada; do
      IMG="screenshots/$BRIEF-$V.png"
      CLS=""; [ "$V" = "ada" ] && CLS=" ada"
      if [ -f "$IMG" ]; then
        echo "<div><img src=\"$IMG\"><div class=\"lbl$CLS\">$V</div></div>"
      else
        echo "<div><div style=\"padding:40px 0;color:#666\">compile failed</div><div class=\"lbl$CLS\">$V</div></div>"
      fi
    done
    echo "</div>"
  done
  echo '</body></html>'
} > RESULTS.html
open RESULTS.html 2>/dev/null || true
