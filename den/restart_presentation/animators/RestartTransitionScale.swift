//

import UIKit

class RestartTransitionScale: NSObject, RestartTransitionAnimator {
    var presenting = false
    var initialFrame: CGRect
    
    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let view = ctx.view(forKey: presenting ? .to : .from) ?! "context is missing views"
        if presenting {
            ctx.containerView.addSubview(view)
            view.frame = initialFrame
            
            let controller = ctx.viewController(forKey: .to) ?! "context is missing to view controller"
            let finalFrame = ctx.finalFrame(for: controller)
            guard ctx.isAnimated else {
                view.frame = finalFrame
                return
            }
            UIView.animate(withDuration: transitionDuration(using: ctx), animations: {
                view.frame = finalFrame
            }) {
                ctx.completeTransition($0)
            }
        }
        else {
            initialFrame = view.frame
            if ctx.isAnimated {
                ctx.completeTransition(true)
            }
        }
    }
}
