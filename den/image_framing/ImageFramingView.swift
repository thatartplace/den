//

import UIKit

class ImageFramingView: UIView {
    private var imageView: UIImageView!
    private var bitmap: ImageBitmap<RGBA32BigPixel>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        reframeImage(position: position)
    }
    
    func reframeImage(position: ImageFramingPosition) {
        guard let bitmap = bitmap else {
            return
        }
        let defaultSize = CGSize(width: bitmap.width, height: bitmap.height)
        let newSize = fitRect(defaultSize, in: bounds.size)
        var origin = CGPoint(x: 0, y: 0)
        let centerOriginX = (bounds.width - newSize.width) / 2
        let centerOriginY = (bounds.height - newSize.height) / 2
        switch position {
        case .top:
            origin = CGPoint(x: centerOriginX, y: 0)
        case .left:
            origin = CGPoint(x: 0, y: centerOriginY)
        case .bottom:
            origin = CGPoint(x: centerOriginX, y: bounds.height - newSize.height)
        case .right:
            origin = CGPoint(x: bounds.width - newSize.width, y: centerOriginY)
        case .center:
            origin = CGPoint(x: centerOriginX, y: centerOriginY)
        }
        imageView.frame = CGRect(origin: origin, size: newSize)
    }
    
    func fitRect(_ rect: CGSize, in container: CGSize) -> CGSize {
        let wRatio = container.width / rect.width
        let hRatio = container.height / rect.height
        let scale = min(hRatio, wRatio)
        return CGSize(width: rect.width * scale, height: rect.height * scale)
    }
    
    var background = ImageFramingBackground.borderColorMode {
        didSet {
            reColor(background: background)
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
            reColor(background: background)
            reframeImage(position: position)
        }
    }
    
    func convertImage(_ image: CGImage) -> ImageBitmap<RGBA32BigPixel> {
        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else {
            preconditionFailure("can't create system defined color space")
        }
        return ImageBitmap(convertFrom: image, bytesPerRow: image.width * 4, format: .RGBA8, space: space)
    }
    
    func reColor(background: ImageFramingBackground) {
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
