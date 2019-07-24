//

import UIKit

protocol RePresentTransitionAnimator: RePresentTransition {
    func animateDismiss(using: UIViewControllerContextTransitioning, done: @escaping (Bool) -> Void)
    func animatePresent(using: UIViewControllerContextTransitioning, done: @escaping (Bool) -> Void)
    func dismissDuration(using: UIViewControllerContextTransitioning) -> TimeInterval
    func presentDuration(using: UIViewControllerContextTransitioning) -> TimeInterval
}

extension RePresentTransitionAnimator {
    func perform(using ctx: UIViewControllerContextTransitioning) {
        prepare(using: ctx)
        if !ctx.isAnimated {
            return
        }
        if state == .dismissing {
            animateDismiss(using: ctx) { _ in
                self.complete(using: ctx)
            }
        }
        else if state == .presenting {
            animatePresent(using: ctx) { _ in
                self.complete(using: ctx)
            }
        }
        else {
            preconditionFailure("undefined animator state")
        }
    }
    
    func duration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let ctx = ctx, ctx.isAnimated else {
            return 0
        }
        switch state {
        case .dismissing:
            return dismissDuration(using: ctx)
        case .presenting:
            return presentDuration(using: ctx)
        default:
            return 0
        }
    }
    
    func complete(using ctx: UIViewControllerContextTransitioning) {
        let cancelled = ctx.transitionWasCancelled
        if state == .dismissing {
            state = cancelled ? .presented : .dismissed
        }
        else if state == .presenting {
            state = cancelled ? .dismissed : .presented
        }
        else {
            preconditionFailure("undefined animator state")
        }
        /// - todo: undo views???
        ctx.completeTransition(!cancelled)
    }
    
    func prepare(using ctx: UIViewControllerContextTransitioning) {
        guard let toView = ctx.view(forKey: .to) else {
            return
        }
        guard let to = ctx.viewController(forKey: .to) else {
            return
        }
        let container = ctx.containerView
        
        container.addSubview(toView)
        if !ctx.isAnimated {
            let toFrame = ctx.finalFrame(for: to)
            toView.frame = toFrame
            /// - todo: configure fromView????
        }
    }
}
