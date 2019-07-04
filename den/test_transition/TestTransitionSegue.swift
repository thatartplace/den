//

import UIKit

class TestTransitionSegue: UIStoryboardSegue {
    override func perform() {
        let delegate = TestTransitionDelegate()
        destination.transitioningDelegate = delegate
        destination.modalPresentationStyle = .formSheet
        source.present(destination, animated: true)
    }
}
