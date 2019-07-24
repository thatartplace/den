//

import UIKit

class RePresentViewController: UIViewController {
    @IBAction func changePresentation(_ sender: Any) {
        modalPresentationStyle = modalPresentationStyle == .pageSheet ? .formSheet : .pageSheet
        rePresent(style: .scale)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func repeatChange(_ sender: Any) {
        10.times { _ in changePresentation(sender) }
    }
}
