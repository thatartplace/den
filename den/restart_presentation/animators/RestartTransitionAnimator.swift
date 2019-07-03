//

import UIKit

protocol RestartTransitionAnimator: UIViewControllerAnimatedTransitioning {
    var presenting: Bool { get set }
}
