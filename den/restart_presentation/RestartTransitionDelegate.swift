//

import UIKit

class RestartTransitionDelegate: NSObject {
    let animator: RestartTransitionAnimator
    
    init(anim: PresentationRestartAnimation) {
        switch anim {
        case .scale:
            animator = RestartTransitionScale()
        default:
            animator = RestartTransitionNone()
        }
    }
}

extension RestartTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
}
