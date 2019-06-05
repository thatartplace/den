//

import Foundation

infix operator ?=: AssignmentPrecedence

extension Optional {
    static func ?= (left: inout Optional<Wrapped>, right: Wrapped) {
        if left == nil {
            left = right
        }
    }
}
