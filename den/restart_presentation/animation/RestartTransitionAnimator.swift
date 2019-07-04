//

import UIKit

protocol RestartTransitionAnimator {
    var entering: Bool { get set }
    mutating func present(using: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext)
    mutating func dismiss(using: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext)
    mutating func animate(using: UIViewControllerContextTransitioning)
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval
}

extension RestartTransitionAnimator {
    typealias TransitionViewsContext = (presenting: UIView?, presented: UIView)
    typealias TransitionViewControllersContext = (presenting: UIViewController, presented: UIViewController)
    
    func viewsContext(_ ctx: UIViewControllerContextTransitioning) -> TransitionViewsContext {
        return (
            presenting: ctx.view(forKey: entering ? .from : .to),
            presented: ctx.view(forKey: entering ? .to : .from) ?! "context is missing presented view"
        )
    }
    
    func viewControllersContext(_ ctx: UIViewControllerContextTransitioning) -> TransitionViewControllersContext {
        return (
            presenting: ctx.viewController(forKey: entering ? .from : .to) ?! "context is missing presenting view controller",
            presented: ctx.viewController(forKey: entering ? .to : .from) ?! "context is missing presented view controller"
        )
    }
    
    mutating func animate(using ctx: UIViewControllerContextTransitioning) {
        let views = viewsContext(ctx)
        let controllers = viewControllersContext(ctx)
        if entering {
            present(using: ctx, views: views, viewControllers: controllers)
        }
        else {
            dismiss(using: ctx, views: views, viewControllers: controllers)
        }
    }
    
    func duration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
}
