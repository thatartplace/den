//

import UIKit

class ImageFramingView: UIView {
    private var imageView = UIImageView(image: nil)
    var bitmap: ImageBitmap<RGBA32BigPixel>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
    }
    
    func imageFrame(position: ImageFramingPosition) -> CGRect? {
        guard let bitmap = bitmap else {
            return nil
        }
        let imageSize = fitRect(CGSize(width: bitmap.width, height: bitmap.height), in: bounds.size)
        var origin = CGPoint(x: 0, y: 0)
        let centerOriginX = (bounds.width - imageSize.width) / 2
        let centerOriginY = (bounds.height - imageSize.height) / 2
        switch position {
        case .top:
            origin = CGPoint(x: centerOriginX, y: 0)
        case .left:
            origin = CGPoint(x: 0, y: centerOriginY)
        case .bottom:
            origin = CGPoint(x: centerOriginX, y: bounds.height - imageSize.height)
        case .right:
            origin = CGPoint(x: bounds.width - imageSize.width, y: centerOriginY)
        case .center:
            origin = CGPoint(x: centerOriginX, y: centerOriginY)
        }
        return CGRect(origin: origin, size: imageSize)
    }
    
    func fitRect(_ rect: CGSize, in container: CGSize) -> CGSize {
        let max = min(container.width, container.height)
        let ratio = rect.width / rect.height
        if rect.width > rect.height {
            return CGSize(width: max, height: max / ratio)
        }
        else {
            return CGSize(width: max * ratio, height: max)
        }
    }
    
    var background = ImageFramingBackground.borderColorMode {
        didSet {
            reColor()
        }
    }
    
    var position = ImageFramingPosition.center {
        didSet {
            layoutSubviews()
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            bitmap = newValue?.cgImage != nil ? convertImage(newValue!.cgImage!) : nil
            reColor()
        }
    }
    
    func convertImage(_ image: CGImage) -> ImageBitmap<RGBA32BigPixel> {
        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else {
            preconditionFailure("can't create system defined color space")
        }
        return ImageBitmap(convertFrom: image, bytesPerRow: image.width * 4, format: .RGBA8, space: space)
    }
    
    func reColor() {
        switch background {
        case let .color(color):
            backgroundColor = color
        case .borderColorMode:
            backgroundColor = borderColorMode() ?? UIColor.black
        }
    }
    
    func borderColorMode() -> UIColor? {
        var all: [UIColor: Int] = [:]
        var top = 0
        var topColor: UIColor?
        
        borderForEach { pixel in
            let color = pixel.color
            let count = (all[color] ?? 0) + 1
            if count > top {
                top = count
                topColor = color
            }
            all[color] = count
        }
        return topColor
    }
    
    func borderForEach(repeated: (RGBA32BigPixel) -> Void) {
        guard let bitmap = bitmap else {
            return
        }
        guard bitmap.width > 0 && bitmap.height > 0 else {
            return
        }
        bitmap.height.times { y in
            if y == 0 || y == bitmap.height - 1 {
                bitmap.width.times { x in repeated(bitmap[x, y]) }
            }
            else {
                repeated(bitmap[0, y])
                repeated(bitmap[bitmap.width - 1, y])
            }
        }
    }
}
