//

import UIKit

class TestTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var presenting = false
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let container = ctx.containerView
        
        if presenting {
            let to = ctx.view(forKey: .to)!
            let finalFrame = ctx.finalFrame(for: ctx.viewController(forKey: .to)!)
            container.addSubview(to)
            to.frame = finalFrame.offsetBy(dx: -container.bounds.width, dy: 0)
            UIView.animate(withDuration: 1.5, animations: {
                to.frame = finalFrame
            }) {
                ctx.completeTransition($0)
            }
        }
        else {
            let from = ctx.view(forKey: .from)!
            UIView.animate(withDuration: 1.5, animations: {
                from.frame = from.frame.offsetBy(dx: container.bounds.width, dy: 0)
            }) {
                ctx.completeTransition($0)
            }
        }
    }
}
