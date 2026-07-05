// Collage builder — composes REAL simulator screenshots into before/after images.
// Pure CoreGraphics + CoreText + ImageIO (no AppKit) so it runs headless anywhere.
// Usage: collage <screenshotsDir> <outDir>
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let cliArgs = CommandLine.arguments
let shotsDir = cliArgs.count > 1 ? cliArgs[1] : "screenshots"
let outDir = cliArgs.count > 2 ? cliArgs[2] : "collages"
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [r, g, b, a])!
}
let bg = rgba(0.055, 0.055, 0.07)
let beforeGray = rgba(0.60, 0.60, 0.62)
let afterGreen = rgba(0.35, 0.85, 0.55)
let white = rgba(1, 1, 1)
let dimWhite = rgba(0.62, 0.62, 0.65)

func loadImage(_ path: String) -> CGImage? {
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil)
    else { return nil }
    return CGImageSourceCreateImageAtIndex(src, 0, nil)
}

struct Pair { let name: String; let before: CGImage; let after: CGImage }

let fm = FileManager.default
let files = (try? fm.contentsOfDirectory(atPath: shotsDir)) ?? []
var pairs: [Pair] = []
for b in files.filter({ $0.hasSuffix("-before.png") }).sorted() {
    let name = String(b.dropLast("-before.png".count))
    let a = "\(name)-after.png"
    guard files.contains(a),
          let bi = loadImage("\(shotsDir)/\(b)"),
          let ai = loadImage("\(shotsDir)/\(a)") else { continue }
    pairs.append(Pair(name: name, before: bi, after: ai))
}
guard !pairs.isEmpty else { print("no before/after pairs found in \(shotsDir)"); exit(1) }

func makeContext(w: Int, h: Int) -> CGContext {
    CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
              space: CGColorSpace(name: CGColorSpace.sRGB)!,
              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
}

func savePNG(_ ctx: CGContext, _ path: String) {
    let img = ctx.makeImage()!
    let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL,
                                               UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, img, nil)
    CGImageDestinationFinalize(dest)
}

// Font loading with a headless-safe fallback: if the normal CoreText lookup
// returns a font with no real glyphs (sandboxed/headless environments), load
// the font file straight from disk.
func hasGlyphs(_ f: CTFont) -> Bool {
    var ch: UniChar = 65
    var glyph = CGGlyph()
    return CTFontGetGlyphsForCharacters(f, &ch, &glyph, 1) && glyph != 0
}

var fontCache: [String: CTFont] = [:]
func font(_ size: CGFloat, bold: Bool) -> CTFont {
    let key = "\(bold)-\(size)"
    if let f = fontCache[key] { return f }
    let name = bold ? "HelveticaNeue-Bold" : "HelveticaNeue-Medium"
    var result = CTFontCreateWithName(name as CFString, size, nil)
    if !hasGlyphs(result) {
        outer: for path in ["/System/Library/Fonts/HelveticaNeue.ttc",
                            "/System/Library/Fonts/Helvetica.ttc"] {
            let url = URL(fileURLWithPath: path) as CFURL
            if let descs = CTFontManagerCreateFontDescriptorsFromURL(url) as? [CTFontDescriptor] {
                // prefer the face matching our weight
                var pick: CTFontDescriptor? = nil
                for d in descs {
                    let n = (CTFontDescriptorCopyAttribute(d, kCTFontNameAttribute) as? String) ?? ""
                    if bold && n.hasSuffix("-Bold") { pick = d; break }
                    if !bold && (n.hasSuffix("-Medium") || n == "HelveticaNeue" || n == "Helvetica") { pick = d; break }
                }
                if pick == nil { pick = descs.first }
                if let p = pick {
                    let f = CTFontCreateWithFontDescriptor(p, size, nil)
                    if hasGlyphs(f) { result = f; break outer }
                }
            }
        }
    }
    fontCache[key] = result
    return result
}

func drawText(_ ctx: CGContext, _ s: String, x: CGFloat, y: CGFloat, size: CGFloat,
              bold: Bool, color: CGColor, kern: CGFloat = 0, centerWidth: CGFloat? = nil) {
    let attrs: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(kCTFontAttributeName as String): font(size, bold: bold),
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color,
        NSAttributedString.Key(kCTKernAttributeName as String): kern as NSNumber,
    ]
    let line = CTLineCreateWithAttributedString(
        NSAttributedString(string: s, attributes: attrs))
    let width = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
    var px = x
    if let cw = centerWidth { px = x + (cw - width) / 2 }
    ctx.saveGState()
    ctx.textMatrix = .identity
    ctx.textPosition = CGPoint(x: px, y: y)
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

func drawShot(_ ctx: CGContext, _ img: CGImage, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
    let rect = CGRect(x: x, y: y, width: w, height: h)
    let path = CGPath(roundedRect: rect, cornerWidth: 18, cornerHeight: 18, transform: nil)
    ctx.saveGState()
    ctx.addPath(path)
    ctx.clip()
    ctx.interpolationQuality = .high
    ctx.draw(img, in: rect)
    ctx.restoreGState()
    ctx.saveGState()
    ctx.addPath(path)
    ctx.setStrokeColor(rgba(1, 1, 1, 0.12))
    ctx.setLineWidth(1.5)
    ctx.strokePath()
    ctx.restoreGState()
}

// --- Per-pair image: BEFORE | AFTER side by side ----------------------------
let shotH: CGFloat = 880
for p in pairs {
    let ratio = CGFloat(p.before.width) / CGFloat(p.before.height)
    let shotW = (shotH * ratio).rounded()
    let pad: CGFloat = 36
    let header: CGFloat = 96
    let W = Int(pad * 3 + shotW * 2)
    let H = Int(pad * 2 + shotH + header)

    let ctx = makeContext(w: W, h: H)
    ctx.setFillColor(bg)
    ctx.fill(CGRect(x: 0, y: 0, width: CGFloat(W), height: CGFloat(H)))
    let title = p.name.replacingOccurrences(of: "-", with: "  ").uppercased()
    drawText(ctx, title, x: pad, y: CGFloat(H) - 62, size: 26, bold: true, color: white, kern: 2)
    drawText(ctx, "BEFORE", x: pad, y: pad + shotH + 14, size: 15, bold: true,
             color: beforeGray, kern: 2, centerWidth: shotW)
    drawText(ctx, "AFTER — SKILL APPLIED", x: pad * 2 + shotW, y: pad + shotH + 14, size: 15,
             bold: true, color: afterGreen, kern: 2, centerWidth: shotW)
    drawShot(ctx, p.before, x: pad, y: pad, w: shotW, h: shotH)
    drawShot(ctx, p.after, x: pad * 2 + shotW, y: pad, w: shotW, h: shotH)
    savePNG(ctx, "\(outDir)/pair-\(p.name).png")
    print("wrote pair-\(p.name).png")
}

// --- Hero collage: top row = all afters, bottom row = all befores ------------
let hShotH: CGFloat = 500
let hRatio = CGFloat(pairs[0].before.width) / CGFloat(pairs[0].before.height)
let hShotW = (hShotH * hRatio).rounded()
let gap: CGFloat = 18
let pad: CGFloat = 48
let titleH: CGFloat = 120
let rowGap: CGFloat = 76
let n = CGFloat(pairs.count)
let W = Int(pad * 2 + hShotW * n + gap * (n - 1))
let H = Int(pad * 2 + titleH + hShotH * 2 + rowGap)

let ctx = makeContext(w: W, h: H)
ctx.setFillColor(bg)
ctx.fill(CGRect(x: 0, y: 0, width: CGFloat(W), height: CGFloat(H)))
drawText(ctx, "ADA-GRADE SWIFTUI SKILL", x: pad, y: CGFloat(H) - 70, size: 34,
         bold: true, color: white, kern: 3)
drawText(ctx, "\(pairs.count) screens · real iOS Simulator renders · same prompts, with and without the skill",
         x: pad, y: CGFloat(H) - 104, size: 17, bold: false, color: dimWhite)

let afterY = pad + hShotH + rowGap
let beforeY = pad
drawText(ctx, "AFTER", x: pad, y: afterY + hShotH + 16, size: 16, bold: true,
         color: afterGreen, kern: 3)
drawText(ctx, "BEFORE", x: pad, y: beforeY + hShotH + 16, size: 16, bold: true,
         color: beforeGray, kern: 3)

for (i, p) in pairs.enumerated() {
    let x = pad + CGFloat(i) * (hShotW + gap)
    drawShot(ctx, p.after, x: x, y: afterY, w: hShotW, h: hShotH)
    drawShot(ctx, p.before, x: x, y: beforeY, w: hShotW, h: hShotH)
}
savePNG(ctx, "\(outDir)/hero.png")
print("wrote hero.png (\(pairs.count) pairs)")
