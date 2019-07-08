//

import UIKit

class RePresentViewController: UIViewController {
    @IBAction func changePresentation(_ sender: Any) {
        modalPresentationStyle = modalPresentationStyle == .pageSheet ? .formSheet : .pageSheet
        rePresent(animation: .scale)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}
