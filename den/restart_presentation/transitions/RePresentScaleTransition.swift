//

import UIKit

class RePresentScaleTransition: NSObject, RePresentTwoStepTransition {
    var state = RePresentTransitionState.presented
    var snapshot: UIView?
    var presentedFrame = CGRect.zero
    
    func performInitial(using: UIViewControllerContextTransitioning) {
    }
    
    func performFinal(using: UIViewControllerContextTransitioning) {
    }
    
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval {
        return state == .dismissing || state == .dismissed ? 0 : 1
    }
}
