//

import UIKit

extension UIView.AnimationCurve {
    var animationOption: UIView.AnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        default:
            return []
        }
    }
}
