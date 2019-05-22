//

import UIKit

extension CALayer {
    func fit(frame: CGRect) {
        self.frame = frame
        sublayers?.forEach { $0.fit(frame: bounds) }
    }
}
