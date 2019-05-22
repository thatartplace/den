//

import UIKit

extension CATransformLayer {
    
    convenience init(rotated: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self.init()
        
        transform = CATransform3DRotate(CATransform3DIdentity, rotated, x, y, z)
    }
    
    convenience init(rotatingFrom from: CGFloat,
                     rotatingTo to: CGFloat,
                     onAxis axis: (CGFloat, CGFloat, CGFloat),
                     duration: CFTimeInterval,
                     autoReverse: Bool = false,
                     repeatCount: Float = 0) {
        self.init()
        let (x, y, z) = axis
        
        let anim = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        anim.values = [from, (to - from) / 2, to].map { CATransform3DMakeRotation($0, x, y, z) }
        anim.duration = duration
        anim.autoreverses = autoReverse
        anim.repeatCount = repeatCount
        add(anim, forKey: "rotation_\(from)_\(to)_\(x)_\(y)_\(z)")
    }
}
