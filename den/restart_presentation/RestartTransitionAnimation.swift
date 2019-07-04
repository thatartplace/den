//

import UIKit

enum RestartTransitionAnimation {
    case none
    case scale
    
    var animateDismiss: Bool {
        return self != .none
    }
    
    var animatePresent: Bool {
        return self != .none
    }
}
