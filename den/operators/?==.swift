//

import Foundation

infix operator ?==: ComparisonPrecedence

extension Optional where Wrapped: Equatable {
    static func ?== (left: Optional, right: Optional) -> Bool {
        guard let l = left, let r = right else {
            return true
        }
        return l == r
    }
}
