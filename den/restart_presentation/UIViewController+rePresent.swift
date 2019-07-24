//

import UIKit

extension UIViewController {
    // invariant: first in, first used (dismissed & present), first out
    private static var queues: [UIViewController: [RePresentContext]] = [:]
    
    /// first dismiss, then present the presented view controller. if the callee isn't
    /// presenting any view controllers, the call is recursively passed along to the
    /// callee's presenting view controller, if one exists.
    /// - warning: this method changes the presented vc's transtioningDelegate property
    /// for the duration of the transition, then restores the old delegate after all
    /// animations finish. you may not modify transtioningDelegate until post handler
    /// is called
    /// - warning: not thread safe, only call me on main queue
    /// - parameters:
    ///     - pre: called before the transitions begin. the presented vc is passed as argument
    ///     - post: called after all animations finish. presented vc is passed as argument
    func rePresent(style: RePresentStyle,
                   pre: ((UIViewController) -> Void)? = nil,
                   post: ((UIViewController) -> Void)? = nil) {
        guard let presented = presentedViewController else {
            presentingViewController?.rePresent(style: style, pre: pre, post: post)
            return
        }
        guard let presenting = presented.presentingViewController else {
            return
        }
        let ctx = RePresentContext(for: presenting, style: style, pre: pre, post: post)
        if enqueue(ctx, for: presenting) == 1 {
            ctx.start {
                self.startNext(for: presenting)
            }
        }
    }
    
    private func startNext(for vc: UIViewController) {
        dequeue(for: vc)?.start {
            self.startNext(for: vc)
        }
    }
    
    private func enqueue(_ ctx: RePresentContext, for vc: UIViewController) -> Int {
        var queue = UIViewController.queues[vc] ?? []
        queue.append(ctx)
        UIViewController.queues[vc] = queue
        return queue.count
    }
    
    private func dequeue(for vc: UIViewController) -> RePresentContext? {
        UIViewController.queues[vc]?.removeFirst()
        return UIViewController.queues[vc]?.first
    }
}
