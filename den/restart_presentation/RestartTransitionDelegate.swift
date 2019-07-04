//

import UIKit

class RestartTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let animator: RestartTransitionAnimator
    
    init(animation: RestartTransitionAnimation, currentFrame: CGRect) {
        switch animation {
        case .scale:
            animator = RestartTransitionScale(initialFrame: currentFrame)
        default:
            animator = RestartTransitionNone()
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
}
