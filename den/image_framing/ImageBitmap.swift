//

import UIKit

class ImageBitmap<Pixel>: Bitmap2D {
    typealias Value = Pixel
    
    private let pixels: UnsafeMutableBufferPointer<Pixel>
    let width: Int
    let height: Int
    private let free: Bool
    
    init(using data: inout Data, width: Int, height: Int) {
        free = false
        pixels = data.withUnsafeMutableBytes { $0.bindMemory(to: Pixel.self) }
        self.width = width
        self.height = height
    }
    
    init(convertFrom image: CGImage, bytesPerRow: Int, format: CIFormat, space: CGColorSpace) {
        let context = CIContext(options: [
            CIContextOption.outputColorSpace: space,
            CIContextOption.outputPremultiplied: false
        ])
        free = true
        pixels = .allocate(capacity: bytesPerRow * image.height)
        guard let base = pixels.baseAddress else {
            preconditionFailure("can't allocate buffer for conversion")
        }
        context.render(CIImage(cgImage: image),
                       toBitmap: base,
                       rowBytes: bytesPerRow,
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
