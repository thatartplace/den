//

import UIKit

class RestartTransitionNone: NSObject, RestartTransitionAnimator {
    var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
    }
}
