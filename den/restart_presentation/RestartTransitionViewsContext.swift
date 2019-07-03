//

import UIKit

struct RestartTransitionViewsContext {
    let toController: UIViewController
    let fromController: UIViewController
    let to: UIView
    let from: UIView
    let toInitialFrame: CGRect
    let fromInitialFrame: CGRect
    let toFinalFrame: CGRect
    let fromFinalFrame: CGRect
    let container: UIView
    
    init(_ ctx: UIViewControllerContextTransitioning) {
        toController = ctx.viewController(forKey: .to) ?! "context is missing to view controller"
        fromController = ctx.viewController(forKey: .from) ?! "context is missing from view controller"
        if let to = ctx.view(forKey: .to) {
            self.to = to
        }
        else {
            to = toController.view
        }
        if let from = ctx.view(forKey: .from) {
            self.from = from
        }
        else {
            from = fromController.view
        }
        toInitialFrame = ctx.initialFrame(for: toController)
        fromInitialFrame = ctx.initialFrame(for: fromController)
        toFinalFrame = ctx.finalFrame(for: toController)
        fromFinalFrame = ctx.finalFrame(for: fromController)
        container = ctx.containerView
    }
}
