//

import UIKit

extension UIViewController {
    /// first dismiss, then present the presented view controller
    /// if the callee isn't presenting any view controller, the call
    /// is recursively passed along to the callee's presenting view
    /// controller, if one exists.
    /// - parameters:
    ///     - pre: the presented vc is passed as argument
    ///     - post: called after all animations finish. presented vc is passed as argument
    /// - returns:
    ///     the presented vc, nil if callee is not part of any presentation
    @discardableResult
    func rePresent(animation: RePresentTransitionAnimation,
                   pre: ((UIViewController) -> Void)? = nil,
                   post: ((UIViewController) -> Void)? = nil) -> UIViewController? {
        guard let presented = presentedViewController else {
            return presentingViewController?.rePresent(animation: animation, pre: pre, post: post)
        }
        guard let controller = presented.presentationController, controller.presentingViewController == self else {
            return nil
        }
        
        pre?(presented)
        
        let currentFrame = controller.containerView != nil ? controller.frameOfPresentedViewInContainerView : presented.view.frame
        let delegate = Unmanaged.passRetained(RePresentTransitionDelegate(animation: animation, currentFrame: currentFrame))
        let savedDelegate = presented.transitioningDelegate
        
        presented.transitioningDelegate = delegate.takeUnretainedValue()
        dismiss(animated: animation.animateDismiss) {
            self.present(presented, animated: animation.animatePresent) {
                delegate.release()
                presented.transitioningDelegate = savedDelegate
                post?(presented)
            }
        }
        return self
    }
}
