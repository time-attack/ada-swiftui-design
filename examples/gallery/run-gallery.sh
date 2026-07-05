#!/bin/bash
# Skill Gallery — builds one app with 8 doctrine-showcase screens across 8 domains
# and captures a real simulator screenshot of each.
# Usage: bash run-gallery.sh
set -euo pipefail
cd "$(dirname "$0")"

BOLD=$(tput bold 2>/dev/null || true); RESET=$(tput sgr0 2>/dev/null || true)
say() { echo "${BOLD}==> $1${RESET}"; }

screen_name() {
  case "$1" in
    1) echo run ;;      2) echo surf ;;
    3) echo coffee ;;   4) echo breathe ;;
    5) echo delivery ;; 6) echo skytonight ;;
    7) echo evcharge ;; 8) echo plant ;;
  esac
}

# --- simulator ---------------------------------------------------------------
say "Finding an iPhone simulator"
UDID=$(xcrun simctl list devices available | grep -E "iPhone (1[5-9]|[2-9][0-9])" | grep -v "unavailable" | head -1 | grep -oE "[0-9A-F-]{36}") || true
if [ -z "${UDID:-}" ]; then
  UDID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE "[0-9A-F-]{36}") || true
fi
if [ -z "${UDID:-}" ]; then
  echo "No iPhone simulator found. Install an iOS runtime in Xcode > Settings > Components."
  exit 1
fi
STATE=$(xcrun simctl list devices | grep "$UDID" | grep -oE "\((Booted|Shutdown)\)" | tr -d '()')
if [ "$STATE" != "Booted" ]; then
  say "Booting simulator (headless)"
  xcrun simctl boot "$UDID"
fi
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || sleep 8
xcrun simctl status_bar "$UDID" override --time "9:41" --batteryLevel 100 --cellularBars 4 --wifiBars 3 2>/dev/null || true

# --- build -------------------------------------------------------------------
say "Building Gallery.app"
mkdir -p build screenshots
APPDIR="build/Gallery.app"
rm -rf "$APPDIR"; mkdir -p "$APPDIR"
cat > "$APPDIR/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>Gallery</string>
  <key>CFBundleIdentifier</key><string>com.skilleval.gallery</string>
  <key>CFBundleName</key><string>Gallery</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>UILaunchScreen</key><dict/>
  <key>UISupportedInterfaceOrientations</key><array><string>UIInterfaceOrientationPortrait</string></array>
</dict></plist>
PLIST

xcrun -sdk iphonesimulator swiftc \
  -parse-as-library -target arm64-apple-ios17.0-simulator -O \
  -o "$APPDIR/Gallery" GalleryA.swift GalleryB.swift

xcrun simctl uninstall "$UDID" com.skilleval.gallery 2>/dev/null || true
xcrun simctl install "$UDID" "$APPDIR"

# --- capture -----------------------------------------------------------------
for N in 1 2 3 4 5 6 7 8; do
  NAME=$(screen_name "$N")
  OUT="screenshots/gallery-$N-$NAME.png"
  say "Capturing $OUT"
  xcrun simctl terminate "$UDID" com.skilleval.gallery 2>/dev/null || true
  SIMCTL_CHILD_EVAL_SCREEN=$N xcrun simctl launch "$UDID" com.skilleval.gallery >/dev/null
  sleep 2.5
  xcrun simctl io "$UDID" screenshot "$OUT" >/dev/null
  xcrun simctl terminate "$UDID" com.skilleval.gallery 2>/dev/null || true
done

# --- gallery page of the real screenshots -------------------------------------
say "Writing GALLERY.html"
{
  echo '<html><head><meta charset="utf-8"><title>Skill Gallery — 8 domains</title><style>'
  echo 'body{font-family:-apple-system;background:#0d0d0f;color:#eee;margin:24px}'
  echo 'h1{font-size:20px} .sub{color:#888;font-size:13px;margin-bottom:18px}'
  echo '.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}'
  echo '.grid div{text-align:center}'
  echo 'img{width:100%;border-radius:16px;border:1px solid #333}'
  echo '.lbl{font-size:12px;color:#aaa;margin-top:6px;text-transform:uppercase;letter-spacing:1px}'
  echo '</style></head><body>'
  echo '<h1>ADA-Grade SwiftUI Skill — Gallery</h1>'
  echo '<div class=sub>8 domains, one doctrine. Real iOS Simulator renders.</div>'
  echo '<div class=grid>'
  for N in 1 2 3 4 5 6 7 8; do
    NAME=$(screen_name "$N")
    echo "<div><img src=\"screenshots/gallery-$N-$NAME.png\"><div class=lbl>$NAME</div></div>"
  done
  echo '</div></body></html>'
} > GALLERY.html

say "Done. 8 screenshots in gallery/screenshots — opening GALLERY.html"
open GALLERY.html 2>/dev/null || true
