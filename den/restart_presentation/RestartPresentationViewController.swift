//

import UIKit

class RestartPresentationViewController: UIViewController {
    @IBAction func changePresentation(_ sender: Any) {
        modalPresentationStyle = modalPresentationStyle == .fullScreen ? .formSheet : .fullScreen
        presentationController?.restart(animation: .scale)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}
