//

import UIKit

class RestartTransitionScale: NSObject, RestartTransitionAnimator {
    var presenting = false
    var savedFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let controller = ctx.viewController(forKey: presenting ? .to : .from) ?! "context is missing view controllers"
        let view = ctx.view(forKey: presenting ? .to : .from) ?! "context is missing views"
        let container = ctx.containerView
        let finalFrame = ctx.finalFrame(for: controller)
        if presenting {
            container.addSubview(view)
            view.frame = savedFrame
            UIView.animate(withDuration: transitionDuration(using: ctx), animations: {
                view.frame = finalFrame
            }) {
                ctx.completeTransition($0)
            }
        }
        else {
            savedFrame = view.frame
            ctx.completeTransition(true)
        }
    }
}
