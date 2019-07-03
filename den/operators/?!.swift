//

import Foundation

infix operator ?!

extension Optional {
    static func ?!(left: Optional, right: String) -> Wrapped {
        guard let some = left else {
            preconditionFailure(right)
        }
        return some
    }
}
