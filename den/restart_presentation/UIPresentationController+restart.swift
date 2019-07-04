//

import UIKit

extension UIPresentationController {
    func restart(animation: RestartTransitionAnimation, completion: (() -> Void)? = nil) {
        let (presenting, presented, currentFrame) = (
            presentingViewController,
            presentedViewController,
            frameOfPresentedViewInContainerView
        )
        
        let delegate = Unmanaged.passRetained(RestartTransitionDelegate(animation: animation, currentFrame: currentFrame))
        let savedDelegate = presented.transitioningDelegate
        
        presented.transitioningDelegate = delegate.takeUnretainedValue()
        presenting.dismiss(animated: animation.animateDismiss)
        presenting.present(presented, animated: animation.animatePresent) {
            delegate.release()
            presented.transitioningDelegate = savedDelegate
            completion?()
        }
    }
}
