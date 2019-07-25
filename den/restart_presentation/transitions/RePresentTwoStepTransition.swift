//

import UIKit

protocol RePresentTwoStepTransition: RePresentTransition {
    func performInitial(using: UIViewControllerContextTransitioning)
    func performFinal(using: UIViewControllerContextTransitioning)
}

extension RePresentTwoStepTransition {
    func perform(using ctx: UIViewControllerContextTransitioning) {
        stateTransition(.start)
        prepare(using: ctx)
        performInitial(using: ctx)
        if ctx.isAnimated {
            UIView.animate(withDuration: duration(using: ctx), animations: {
                self.performFinal(using: ctx)
            }, completion: { _ in
                self.stateTransition(ctx.transitionWasCancelled ? .cancel : .finish)
                self.performInitial(using: ctx)
                ctx.completeTransition(!self.cancelled)
            })
        }
        else {
            performFinal(using: ctx)
            stateTransition(.finish)
        }
    }
    
    func prepare(using ctx: UIViewControllerContextTransitioning) {
        let container = ctx.containerView
        if let toView = ctx.view(forKey: .to) {
            container.addSubview(toView)
        }
    }
}
