//

import UIKit

typealias TransitionViewsContext = (presenting: UIView?, presented: UIView)
typealias TransitionViewControllersContext = (presenting: UIViewController, presented: UIViewController)

protocol RePresentTransitionAnimator {
    var entering: Bool { get set }
    func present(using: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> Self
    func dismiss(using: UIViewControllerContextTransitioning, views: TransitionViewsContext, viewControllers: TransitionViewControllersContext) -> Self
    func animate(using: UIViewControllerContextTransitioning) -> Self
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval
}

extension RePresentTransitionAnimator {
    func viewsContext(_ ctx: UIViewControllerContextTransitioning) -> TransitionViewsContext {
        return (
            presenting: ctx.view(forKey: entering ? .from : .to),
            presented: ctx.view(forKey: entering ? .to : .from)!
        )
    }
    
    func viewControllersContext(_ ctx: UIViewControllerContextTransitioning) -> TransitionViewControllersContext {
        return (
            presenting: ctx.viewController(forKey: entering ? .from : .to)!,
            presented: ctx.viewController(forKey: entering ? .to : .from)!
        )
    }
    
    func animate(using ctx: UIViewControllerContextTransitioning) -> Self {
        let views = viewsContext(ctx)
        let controllers = viewControllersContext(ctx)
        if entering {
            return present(using: ctx, views: views, viewControllers: controllers)
        }
        else {
            return dismiss(using: ctx, views: views, viewControllers: controllers)
        }
    }
    
    func duration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ctx?.isAnimated == .some(true) ? 0.75 : 0
    }
}
