//

import UIKit

class RestartPresentationViewController: UIViewController {
    @IBAction func changePresentation(_ sender: Any) {
        let styles: [UIModalPresentationStyle] = [
            .formSheet,
            .fullScreen,
            .overFullScreen,
            .pageSheet
        ]
        modalPresentationStyle = styles.randomElement() ?? .formSheet
        presentationController?.restart(anim: .scale)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}
