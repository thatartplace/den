//

import UIKit

enum RePresentTransitionState {
    case presented
    case dismissing
    case dismissed
    case presenting
}

protocol RePresentTransition: AnyObject {
    var state: RePresentTransitionState { get set }
    func perform(using: UIViewControllerContextTransitioning)
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval
}

extension RePresentTransition {
    typealias TransitionContextKeys = (
        presentingView: UITransitionContextViewKey,
        presentedView: UITransitionContextViewKey,
        presentingViewController: UITransitionContextViewControllerKey,
        presentedViewController: UITransitionContextViewControllerKey
    )
    
    var keys: TransitionContextKeys {
        return (
            presentingView: state == .presenting ? .from : .to,
            presentedView: state == .dismissing ? .from : .to,
            presentingViewController: state == .presenting ? .from : .to,
            presentedViewController: state == .dismissing ? .from : .to
        )
    }
}
