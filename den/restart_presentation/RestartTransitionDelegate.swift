//

import UIKit

class RestartTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var animator: RestartTransitionAnimator?
    
    init(animation: RestartTransitionAnimation, currentFrame: CGRect) {
        switch animation {
        case .scale:
            animator = RestartTransitionScale(initialFrame: currentFrame)
        default:
            animator = nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator?.entering = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
