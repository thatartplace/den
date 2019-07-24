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
        
        prepare(using: ctx)
        performInitial(using: ctx)
        if ctx.isAnimated {
            UIView.animate(withDuration: duration(using: ctx), animations: {
                self.performFinal(using: ctx)
            }, completion: { _ in
                self.setCompletionState(using: ctx)
                self.performInitial(using: ctx)
                ctx.completeTransition(!self.cancelled)
            })
        }
        else {
            performFinal(using: ctx)
            setCompletionState(using: ctx)
        }
    }
    
    func prepare(using ctx: UIViewControllerContextTransitioning) {
        let container = ctx.containerView
        if let toView = ctx.view(forKey: .to) {
            container.addSubview(toView)
        }
    }
    
    func setCompletionState(using ctx: UIViewControllerContextTransitioning) {
        let cancelled = ctx.transitionWasCancelled
        self.cancelled = cancelled
        switch state {
        case .dismissing:
            state = cancelled ? .presented : .dismissed
        case .presenting:
            state = cancelled ? .dismissed : .presented
        default:
            preconditionFailure("undefined animator state")
        }
    }
}
