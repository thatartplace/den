//

import UIKit

enum RestartTransitionAnimation {
    case none
    case scale
    
    var animateDismiss: Bool {
        return false
    }
    
    var animatePresent: Bool {
        return self != .none
    }
}
