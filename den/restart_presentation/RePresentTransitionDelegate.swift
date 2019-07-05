//

import UIKit

class RePresentTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var animator: RePresentTransitionAnimator?
    
    init(animation: RePresentTransitionAnimation, currentFrame: CGRect) {
        switch animation {
        case .scale:
            animator = RePresentTransitionScale(initialFrame: currentFrame)
        default:
            animator = nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if animator == nil {
            return nil
        }
        animator?.entering = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if animator == nil {
            return nil
        }
        animator?.entering = true
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animator?.duration(using: transitionContext) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator = animator?.animate(using: transitionContext)
    }
}
