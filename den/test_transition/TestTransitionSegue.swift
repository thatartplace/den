//

import UIKit

class TestTransitionSegue: UIStoryboardSegue {
    let delegate = TestTransitionDelegate()
    var self1: TestTransitionSegue?
    
    override func perform() {
        self1 = self
        destination.transitioningDelegate = delegate
        destination.modalPresentationStyle = .formSheet
        source.present(destination, animated: true)
    }
}
