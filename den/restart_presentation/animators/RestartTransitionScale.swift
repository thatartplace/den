//

import UIKit

class RestartTransitionScale: NSObject, RestartTransitionAnimator {
    var presenting = false
    var initialFrame: CGRect
    var snapshot: UIView?
    
    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let view = ctx.view(forKey: presenting ? .to : .from) ?! "context is missing views"
        let to = ctx.viewController(forKey: .to) ?! "context is missing to view controller"
        if presenting {
            ctx.containerView.addSubview(view)
            snapshot?.removeFromSuperview()
            
            let finalFrame = ctx.finalFrame(for: to)
            if ctx.isAnimated {
                view.frame = initialFrame
                UIView.animate(withDuration: transitionDuration(using: ctx), animations: {
                    view.frame = finalFrame
                }) {
                    ctx.completeTransition($0)
                }
            }
            else {
                view.frame = finalFrame
            }
        }
        else {
            initialFrame = view.frame
            if ctx.isAnimated {
                let snapshot = view.snapshotView(afterScreenUpdates: false) ?! "can't create snapshot of presented view"
                snapshot.frame = view.frame
                self.snapshot = snapshot
                to.view.addSubview(snapshot)
                ctx.completeTransition(true)
            }
        }
    }
}
