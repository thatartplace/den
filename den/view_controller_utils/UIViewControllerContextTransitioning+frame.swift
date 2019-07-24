//

import UIKit

extension UIViewControllerContextTransitioning {
    func initialFrame(for key: UITransitionContextViewControllerKey) -> CGRect? {
        guard let viewController = viewController(forKey: key) else {
            return nil
        }
        return initialFrame(for: viewController)
    }
    
    func finalFrame(for key: UITransitionContextViewControllerKey) -> CGRect? {
        guard let viewController = viewController(forKey: key) else {
            return nil
        }
        return finalFrame(for: viewController)
    }
}
