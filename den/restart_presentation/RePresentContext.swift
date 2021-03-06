//

import UIKit

class RePresentContext: NSObject {
    weak var savedDelegate: UIViewControllerTransitioningDelegate?
    weak var presenting: UIViewController?
    var pre: ((UIViewController) -> Void)?
    var post: ((UIViewController) -> Void)?
    var transition: RePresentTransition?
    
    init(for vc: UIViewController,
         style: RePresentStyle,
         pre: ((UIViewController) -> Void)? = nil,
         post: ((UIViewController) -> Void)? = nil) {
        presenting = vc
        self.pre = pre
        self.post = post
        transition = style.makeTransition()
    }
    
    func start(done: @escaping () -> Void) {
        guard let presenting = presenting else {
            return
        }
        guard let presented = presenting.presentedViewController else {
            return
        }
        
        pre?(presented)
        savedDelegate = presented.transitioningDelegate
        presented.transitioningDelegate = self
        presenting.dismiss(animated: true)
        presenting.present(presented, animated: true) {
            // presentation is not 100% done until this handler returns so
            // don't start the next presentation on current run loop
            DispatchQueue.main.async {
                presented.transitioningDelegate = self.savedDelegate
                self.post?(presented)
                done()
            }
        }
    }
}

extension RePresentContext: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition != nil ? self : nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition != nil ? self : nil
    }
}

extension RePresentContext: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transition?.duration(using: transitionContext) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transition?.perform(using: transitionContext)
    }
}
