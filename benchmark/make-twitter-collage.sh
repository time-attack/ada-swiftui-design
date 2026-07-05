#!/bin/bash
# Renders the flight-tracker variants (if not yet captured) and composes a
# Twitter-ready labeled triptych: no guidance | HIG skill | ADA skill.
# Usage: bash make-twitter-collage.sh
set -euo pipefail
cd "$(dirname "$0")"

# 1. capture any missing screenshots (render-bench skips existing ones)
bash render-bench.sh

# 2. compose the triptych
mkdir -p build
xcrun swiftc -O -o build/triptych ../tools/triptych.swift
./build/triptych twitter-flight.png \
  "Same prompt. Three results." \
  "\"Build a SwiftUI screen for a flight tracker.\" — real simulator renders, same model" \
  screenshots/flight-tracker-baseline.png     "no guidance" \
  screenshots/flight-tracker-comp-wshobson.png "HIG skill" \
  screenshots/flight-tracker-ada.png           "ada skill"

echo "==> twitter-flight.png ready"
open twitter-flight.png 2>/dev/null || true
