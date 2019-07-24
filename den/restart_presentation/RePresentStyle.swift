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
    
    func makeTransition() -> RePresentTransition? {
        switch self {
        case .scale:
            return RePresentScaleTransition()
        default:
            return nil
        }
    }
}
