//

import UIKit

struct RePresentTransitionScale: RePresentTransitionAnimator {
    var entering = false
    var initialFrame: CGRect
    var snapshot: UIView?
    
    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
    }
    
    func present(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> RePresentTransitionScale {
        let presented = views.presented
        let container = ctx.containerView
        let finalFrame = ctx.finalFrame(for: viewControllers.presented)
        
        snapshot?.removeFromSuperview()
        container.addSubview(presented)
        if ctx.isAnimated {
            presented.frame = initialFrame
            UIView.animate(withDuration: duration(using: ctx), animations: {
                presented.frame = finalFrame
            }) {
                ctx.completeTransition($0 && !ctx.transitionWasCancelled)
            }
        }
        else {
            presented.frame = finalFrame
        }
        return self
    }
    
    func dismiss(using ctx: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> RePresentTransitionScale {
        var state = self
        let presentingVC = viewControllers.presenting
        let container = ctx.containerView
        
        if ctx.isAnimated {
            if let snapshot = container.snapshotView(afterScreenUpdates: false) {
                snapshot.frame = container.frame
                presentingVC.view.addSubview(snapshot)
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
