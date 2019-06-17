//

import UIKit

class ImageBitmap<Pixel>: Bitmap2D {
    typealias Value = Pixel
    
    private let pixels: UnsafeMutablePointer<Pixel>
    let width: Int
    let height: Int
    let pixelSize = MemoryLayout<Pixel>.size
    private let free: Bool
    
    init(using data: inout Data?, width: Int, height: Int) {
        if let base = data?.withUnsafeMutableBytes({ $0.baseAddress }) as UnsafeMutableRawPointer? {
            free = false
            pixels = base.assumingMemoryBound(to: Pixel.self)
        }
        else {
            free = true
            pixels = .allocate(capacity: pixelSize * width * height)
        }
        self.width = width
        self.height = height
    }
    
    init(convertFrom image: CGImage, format: CIFormat, space: CGColorSpace) {
        let context = CIContext(options: [
            CIContextOption.workingColorSpace: space,
            CIContextOption.outputPremultiplied: false
        ])
        free = true
        pixels = .allocate(capacity: pixelSize * image.width * image.height)
        context.render(CIImage(cgImage: image),
                       toBitmap: pixels,
                       rowBytes: pixelSize * image.width,
                       bounds: CGRect(x: 0, y: 0, width: image.width, height: image.height),
                       format: format,
                       colorSpace: nil)
        width = image.width
        height = image.height
    }
    
    deinit {
        if free {
            pixels.deallocate()
        }
    }
    
    subscript(x: Int, y: Int) -> Pixel {
        get {
            precondition(x >= 0 && y >= 0, "x and y must be non negative")
            precondition(x < width && y < height, "asking for pixel at (\(x), \(y)) but that's beyond the bitmap's size")
            return pixels[y * width + x]
        }
        set {
            precondition(x >= 0 && y >= 0, "x and y must be non negative")
            precondition(x < width && y < height, "setting value at (\(x), \(y)) but that's beyond the bitmap's size")
            pixels[y * width + x] = newValue
        }
    }
}
