//

import UIKit

class RePresentViewController: UIViewController {
    @IBAction func changePresentation(_ sender: Any) {
        modalPresentationStyle = modalPresentationStyle == .fullScreen ? .formSheet : .fullScreen
        rePresent(animation: .scale)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}
