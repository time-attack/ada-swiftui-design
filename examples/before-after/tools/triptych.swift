// Triptych composer — three labeled phone renders on a dark canvas, sized for
// a Twitter/X post. Pure CoreGraphics + CoreText + ImageIO.
// Usage: triptych <out.png> <title> <subtitle> <img1> <label1> <img2> <label2> <img3> <label3>
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let a = CommandLine.arguments
guard a.count >= 10 else {
    print("usage: triptych <out.png> <title> <subtitle> <img1> <label1> <img2> <label2> <img3> <label3>")
    exit(1)
}
let outPath = a[1], title = a[2], subtitle = a[3]
let panels: [(String, String)] = [(a[4], a[5]), (a[6], a[7]), (a[8], a[9])]

func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ al: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [r, g, b, al])!
}
func load(_ p: String) -> CGImage? {
    guard let s = CGImageSourceCreateWithURL(URL(fileURLWithPath: p) as CFURL, nil) else { return nil }
    return CGImageSourceCreateImageAtIndex(s, 0, nil)
}
let imgs = panels.compactMap { load($0.0) }
guard imgs.count == 3 else { print("could not load all 3 images"); exit(1) }

var fontCache: [String: CTFont] = [:]
func font(_ size: CGFloat, bold: Bool) -> CTFont {
    let key = "\(bold)-\(size)"
    if let f = fontCache[key] { return f }
    let f = CTFontCreateWithName((bold ? "HelveticaNeue-Bold" : "HelveticaNeue-Medium") as CFString, size, nil)
    fontCache[key] = f
    return f
}
func drawText(_ ctx: CGContext, _ s: String, x: CGFloat, y: CGFloat, size: CGFloat,
              bold: Bool, color: CGColor, kern: CGFloat = 0, centerWidth: CGFloat? = nil) {
    let attrs: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(kCTFontAttributeName as String): font(size, bold: bold),
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color,
        NSAttributedString.Key(kCTKernAttributeName as String): kern as NSNumber,
    ]
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: attrs))
    let width = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
    var px = x
    if let cw = centerWidth { px = x + (cw - width) / 2 }
    ctx.saveGState()
    ctx.textMatrix = .identity
    ctx.textPosition = CGPoint(x: px, y: y)
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

let shotH: CGFloat = 1100
let ratio = CGFloat(imgs[0].width) / CGFloat(imgs[0].height)
let shotW = (shotH * ratio).rounded()
let gap: CGFloat = 30
let pad: CGFloat = 60
let labelH: CGFloat = 56
let titleH: CGFloat = 150
let W = Int(pad * 2 + shotW * 3 + gap * 2)
let H = Int(pad * 2 + titleH + shotH + labelH)

let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0,
                    space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

let grad = CGGradient(colorsSpace: space, colors: [
    rgba(0.09, 0.09, 0.13), rgba(0.04, 0.04, 0.06),
] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: CGFloat(H)), end: .zero, options: [])
let glow = CGGradient(colorsSpace: space, colors: [
    rgba(0.30, 0.60, 0.90, 0.14), rgba(0, 0, 0, 0),
] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(glow, startCenter: CGPoint(x: CGFloat(W)/2, y: CGFloat(H)+80),
                       startRadius: 0, endCenter: CGPoint(x: CGFloat(W)/2, y: CGFloat(H)+80),
                       endRadius: CGFloat(W) * 0.7, options: [])

// title block
drawText(ctx, title, x: pad, y: CGFloat(H) - 82, size: 44, bold: true,
         color: rgba(1, 1, 1), kern: 1)
drawText(ctx, subtitle, x: pad, y: CGFloat(H) - 128, size: 22, bold: false,
         color: rgba(0.62, 0.62, 0.66))

let labelColors: [CGColor] = [rgba(0.62, 0.62, 0.66), rgba(0.45, 0.68, 0.95), rgba(0.30, 0.85, 0.55)]
for (i, img) in imgs.enumerated() {
    let x = pad + CGFloat(i) * (shotW + gap)
    let y = pad + labelH
    let rect = CGRect(x: x, y: y, width: shotW, height: shotH)
    let path = CGPath(roundedRect: rect, cornerWidth: 34, cornerHeight: 34, transform: nil)
    // shadow card
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 30, color: rgba(0, 0, 0, 0.55))
    ctx.addPath(path)
    ctx.setFillColor(rgba(0.05, 0.05, 0.07))
    ctx.fillPath()
    ctx.restoreGState()
    // image
    ctx.saveGState()
    ctx.addPath(path)
    ctx.clip()
    ctx.interpolationQuality = .high
    ctx.draw(img, in: rect)
    ctx.restoreGState()
    // hairline
    ctx.saveGState()
    ctx.addPath(path)
    ctx.setStrokeColor(i == 2 ? rgba(0.30, 0.85, 0.55, 0.45) : rgba(1, 1, 1, 0.13))
    ctx.setLineWidth(i == 2 ? 2.5 : 1.5)
    ctx.strokePath()
    ctx.restoreGState()
    // label
    drawText(ctx, panels[i].1.uppercased(), x: x, y: pad + 8, size: 21, bold: true,
             color: labelColors[i], kern: 3, centerWidth: shotW)
}

let out = ctx.makeImage()!
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outPath) as CFURL,
                                           UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, out, nil)
CGImageDestinationFinalize(dest)
print("wrote \(outPath) (\(W)x\(H))")
