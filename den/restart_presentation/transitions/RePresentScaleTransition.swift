//

import UIKit

class RePresentScaleTransition: NSObject, RePresentTransitionAnimator {
    var state = RePresentTransitionState.presented
    
    func animateDismiss(using ctx: UIViewControllerContextTransitioning, done: @escaping (Bool) -> Void) {
    }
    
    func animatePresent(using ctx: UIViewControllerContextTransitioning, done: @escaping (Bool) -> Void) {
    }
    
    func dismissDuration(using: UIViewControllerContextTransitioning) -> TimeInterval {
        return 0
    }
    
    func presentDuration(using: UIViewControllerContextTransitioning) -> TimeInterval {
        return 1
    }
}
