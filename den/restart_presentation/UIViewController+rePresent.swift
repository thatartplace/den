//

import UIKit

extension UIViewController {
    /// first dismiss, then present the presented view controller
    /// if the callee is not presented, but one of its ancestors is,
    /// that ancestor is re-presented instead
    /// - parameters:
    ///     - pre: the presented vc is passed as argument
    ///     - post: called after all animations finish. presented vc is passed as argument
    func rePresent(animation: RePresentTransitionAnimation,
                   pre: ((UIViewController) -> Void)? = nil,
                   post: ((UIViewController) -> Void)? = nil) {
        guard let presenting = presentingViewController else {
            return
        }
        guard let presented = presenting.presentedViewController else {
            return
        }
        
        pre?(presented)
        
        let delegate = Unmanaged.passRetained(RePresentTransitionDelegate(animation: animation))
        let savedDelegate = presented.transitioningDelegate
        
        presented.transitioningDelegate = delegate.takeUnretainedValue()
        presenting.dismiss(animated: animation.animateDismiss)
        presenting.present(presented, animated: animation.animatePresent) {
            delegate.release()
            presented.transitioningDelegate = savedDelegate
            post?(presented)
        }
    }
}
