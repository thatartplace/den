//

import UIKit

enum RePresentTransitionState {
    case presented
    case dismissing
    case dismissed
    case presenting
}

protocol RePresentTransition: AnyObject {
    var state: RePresentTransitionState { get set }
    var cancelled: Bool { get set }
    func perform(using: UIViewControllerContextTransitioning)
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval
}
