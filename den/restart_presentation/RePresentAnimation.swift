//

import UIKit

enum RePresentAnimation {
    case none
    case scale
    
    var animateDismiss: Bool {
        return self != .none
    }
    
    var animatePresent: Bool {
        return self != .none
    }
}
