//

import UIKit

protocol Pixel {
    var color: UIColor { get }
}

struct RGBA32BigPixel: Pixel {
    let red, green, blue, alpha: UInt8
    
    var color: UIColor {
        let max = CGFloat(UInt8.max)
        let red = CGFloat(self.red) / max
        let green = CGFloat(self.green) / max
        let blue = CGFloat(self.blue) / max
        let alpha = CGFloat(self.alpha) / max
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
