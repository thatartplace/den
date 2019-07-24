//

import UIKit

class RePresentScaleTransition: NSObject, RePresentTwoStepTransition {
    var state = RePresentTransitionState.presented
    var cancelled = false
    var snapshot: UIView?
    var presentedFrame = CGRect.zero
    
    func performInitial(using ctx: UIViewControllerContextTransitioning) {
        let fromView = ctx.view(forKey: .from)
        let toView = ctx.view(forKey: .to)
        let to = ctx.viewController(forKey: .to)
        
        switch state {
        case .dismissing:
            let fromFrame = fromView?.frame ?? CGRect.zero
            presentedFrame = fromFrame
            if let snapshot = fromView?.snapshotView(afterScreenUpdates: false) {
                snapshot.frame = fromFrame
                to?.view.addSubview(snapshot)
                self.snapshot = snapshot
            }
        case .dismissed:
            if cancelled {
                toView?.frame = presentedFrame
            }
        case .presenting:
            toView?.frame = presentedFrame
            fallthrough
        case .presented:
            snapshot?.removeFromSuperview()
            snapshot = nil
        }
    }
    
    func performFinal(using ctx: UIViewControllerContextTransitioning) {
        let toView = ctx.view(forKey: .to)
        if state == .presenting {
            if let toFrame = ctx.finalFrame(for: .to) {
                toView?.frame = toFrame
            }
        }
    }
    
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval {
        return state == .dismissing || state == .dismissed ? 0 : 1
    }
}
