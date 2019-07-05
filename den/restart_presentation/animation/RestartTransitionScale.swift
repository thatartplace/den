//

import UIKit

struct RestartTransitionScale: RestartTransitionAnimator {
    var entering = false
    var initialFrame: CGRect
    var snapshot: UIView?
    
    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }
    
    func present(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> RestartTransitionScale {
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
        return self
    }
    
    func dismiss(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> RestartTransitionScale {
        var state = self
        let view = views.presented
        let presenting = viewControllers.presenting
        state.initialFrame = view.frame
        if ctx.isAnimated {
            if let snapshot = view.snapshotView(afterScreenUpdates: false) {
                snapshot.frame = view.frame
                presenting.view.addSubview(snapshot)
                state.snapshot = snapshot
            }
            // make sure animator functions return before completeTransition enters
            DispatchQueue.main.async {
                ctx.completeTransition(true)
            }
        }
        return state
    }
}
