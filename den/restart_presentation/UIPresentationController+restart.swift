//

import UIKit

extension UIPresentationController {
    func restart(anim: PresentationRestartAnimation, completion: (() -> Void)? = nil) {
        let (presenting, presented) = (presentingViewController, presentedViewController)
        let savedDelegate = presented.transitioningDelegate
        let delegate = RestartTransitionDelegate(anim: anim)
        
        presented.transitioningDelegate = delegate
        presenting.dismiss(animated: true)
        presenting.present(presented, animated: anim != .none) {
            print(delegate)
            presented.transitioningDelegate = savedDelegate
            completion?()
        }
    }
}
