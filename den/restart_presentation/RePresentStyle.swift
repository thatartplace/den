//

import UIKit

enum RePresentStyle {
    case none
    case scale
    
    var animateDismiss: Bool {
        return self != .none
    }
    
    var animatePresent: Bool {
        return self != .none
    }
}
