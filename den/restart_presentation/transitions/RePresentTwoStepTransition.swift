//

import UIKit

protocol RePresentTwoStepTransition: RePresentTransition {
    func performInitial(using: UIViewControllerContextTransitioning)
    func performFinal(using: UIViewControllerContextTransitioning)
}

extension RePresentTwoStepTransition {
    func perform(using ctx: UIViewControllerContextTransitioning) {
        switch state {
        case .presented:
            state = .dismissing
        case .dismissed:
            state = .presenting
        default:
            preconditionFailure("undefined animator state")
        }
        
        guard let toView = ctx.view(forKey: .to) else {
            preconditionFailure("transition context is missing to view")
        }
        ctx.containerView.addSubview(toView)
        
        performInitial(using: ctx)
        if ctx.isAnimated {
            UIView.animate(withDuration: duration(using: ctx), animations: {
                self.performFinal(using: ctx)
            }, completion: { _ in
                self.state = self.completionState(using: ctx)
                self.performInitial(using: ctx)
                ctx.completeTransition(!ctx.transitionWasCancelled)
            })
        }
        else {
            performFinal(using: ctx)
            state = completionState(using: ctx)
        }
    }
    
    func completionState(using ctx: UIViewControllerContextTransitioning) -> RePresentTransitionState {
        let cancelled = ctx.transitionWasCancelled
        switch state {
        case .dismissing:
            return cancelled ? .presented : .dismissed
        case .presenting:
            return cancelled ? .dismissed : .presented
        default:
            preconditionFailure("undefined animator state")
        }
    }
}
