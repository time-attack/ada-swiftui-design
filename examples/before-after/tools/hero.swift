// Hero composer — big, clean, text-free grid of real renders.
// Pure CoreGraphics/ImageIO. Usage: hero <outPath> <img1> <img2> ... (4 or 8 images)
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let a = CommandLine.arguments
guard a.count >= 3 else { print("usage: hero <out.png> <images...>"); exit(1) }
let outPath = a[1]
let paths = Array(a.dropFirst(2))

func load(_ p: String) -> CGImage? {
    guard let s = CGImageSourceCreateWithURL(URL(fileURLWithPath: p) as CFURL, nil) else { return nil }
    return CGImageSourceCreateImageAtIndex(s, 0, nil)
}
let imgs = paths.compactMap(load)
guard !imgs.isEmpty else { print("no images loaded"); exit(1) }

let cols = imgs.count >= 8 ? 4 : imgs.count
let rows = Int(ceil(Double(imgs.count) / Double(cols)))
let shotW: CGFloat = 470
let ratio = CGFloat(imgs[0].height) / CGFloat(imgs[0].width)
let shotH = (shotW * ratio).rounded()
let gap: CGFloat = 34
let pad: CGFloat = 56
let W = Int(pad * 2 + shotW * CGFloat(cols) + gap * CGFloat(cols - 1))
let H = Int(pad * 2 + shotH * CGFloat(rows) + gap * CGFloat(rows - 1))

let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0,
                    space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

// canvas: deep tinted vertical gradient, faint radial glow top-center
let gradient = CGGradient(colorsSpace: space, colors: [
    CGColor(colorSpace: space, components: [0.09, 0.09, 0.13, 1])!,
    CGColor(colorSpace: space, components: [0.04, 0.04, 0.06, 1])!,
] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: CGFloat(H)),
                       end: CGPoint(x: 0, y: 0), options: [])
let glow = CGGradient(colorsSpace: space, colors: [
    CGColor(colorSpace: space, components: [0.35, 0.55, 0.9, 0.16])!,
    CGColor(colorSpace: space, components: [0, 0, 0, 0])!,
] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(glow, startCenter: CGPoint(x: CGFloat(W) / 2, y: CGFloat(H) + 100),
                       startRadius: 0, endCenter: CGPoint(x: CGFloat(W) / 2, y: CGFloat(H) + 100),
                       endRadius: CGFloat(W) * 0.75, options: [])

for (i, img) in imgs.enumerated() {
    let col = i % cols, row = i / cols
    let x = pad + CGFloat(col) * (shotW + gap)
    // CG origin is bottom-left; row 0 should be the TOP row
    let y = CGFloat(H) - pad - shotH - CGFloat(row) * (shotH + gap)
    let rect = CGRect(x: x, y: y, width: shotW, height: shotH)

    // soft drop shadow
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -14), blur: 34,
                  color: CGColor(colorSpace: space, components: [0, 0, 0, 0.55])!)
    let path = CGPath(roundedRect: rect, cornerWidth: 30, cornerHeight: 30, transform: nil)
    ctx.addPath(path)
    ctx.setFillColor(CGColor(colorSpace: space, components: [0.05, 0.05, 0.07, 1])!)
    ctx.fillPath()
    ctx.restoreGState()

    ctx.saveGState()
    ctx.addPath(path)
    ctx.clip()
    ctx.interpolationQuality = .high
    ctx.draw(img, in: rect)
    ctx.restoreGState()

    ctx.saveGState()
    ctx.addPath(path)
    ctx.setStrokeColor(CGColor(colorSpace: space, components: [1, 1, 1, 0.14])!)
    ctx.setLineWidth(1.5)
    ctx.strokePath()
    ctx.restoreGState()
}

let out = ctx.makeImage()!
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: outPath) as CFURL,
                                           UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, out, nil)
CGImageDestinationFinalize(dest)
print("wrote \(outPath) (\(W)x\(H), \(imgs.count) shots)")
