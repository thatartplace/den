//

import UIKit

protocol ToCGFloat {
    var cgFloat: CGFloat { get }
}

extension Int: ToCGFloat {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat: ToCGFloat {
    var cgFloat: CGFloat {
        return self
    }
}

func * (left: ToCGFloat, right: ToCGFloat) -> CGFloat {
    return left.cgFloat * right.cgFloat
}

func / (left: ToCGFloat, right: ToCGFloat) -> CGFloat {
    return left.cgFloat / right.cgFloat
}

func + (left: ToCGFloat, right: ToCGFloat) -> CGFloat {
    return left.cgFloat + right.cgFloat
}

func - (left: ToCGFloat, right: ToCGFloat) -> CGFloat {
    return left.cgFloat - right.cgFloat
}
