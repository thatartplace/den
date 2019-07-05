//

import UIKit

extension UIViewController {
    func rePresent(animation: RePresentTransitionAnimation, completion: (() -> Void)? = nil) {
        guard let presented = presentedViewController else {
            presentingViewController?.rePresent(animation: animation, completion: completion)
            return
        }
        guard let controller = presented.presentationController, controller.presentingViewController == self else {
            return
        }
        
        let currentFrame = controller.frameOfPresentedViewInContainerView
        let delegate = Unmanaged.passRetained(RePresentTransitionDelegate(animation: animation, currentFrame: currentFrame))
        let savedDelegate = presented.transitioningDelegate
        
        presented.transitioningDelegate = delegate.takeUnretainedValue()
        dismiss(animated: animation.animateDismiss)
        present(presented, animated: animation.animatePresent) {
            delegate.release()
            presented.transitioningDelegate = savedDelegate
            completion?()
        }
    }
}
