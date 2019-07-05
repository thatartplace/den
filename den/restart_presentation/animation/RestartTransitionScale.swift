//

import UIKit

struct RestartTransitionScale: RestartTransitionAnimator {
    var entering = false
    var initialFrame: CGRect
    var snapshot: UIView?
    
    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }
    
    mutating func present(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) {
        let view = views.presented
        let presented = viewControllers.presented
        ctx.containerView.addSubview(view)
        snapshot?.removeFromSuperview()
        let finalFrame = ctx.finalFrame(for: presented)
        if ctx.isAnimated {
            view.frame = initialFrame
            UIView.animate(withDuration: duration(using: ctx), animations: {
                view.frame = finalFrame
            }) {
                ctx.completeTransition($0 && !ctx.transitionWasCancelled)
            }
        }
        else {
            view.frame = finalFrame
        }
    }
    
    mutating func dismiss(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) {
        let view = views.presented
        let presenting = viewControllers.presenting
        initialFrame = view.frame
        if ctx.isAnimated {
            let snapshot = view.snapshotView(afterScreenUpdates: false) ?! "can't create snapshot of presented view"
            snapshot.frame = view.frame
            self.snapshot = snapshot
            presenting.view.addSubview(snapshot)
            DispatchQueue.main.async {
                ctx.completeTransition(true)
            }
        }
    }
}
