//

import UIKit
import SafariServices

class SafariTestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let safari = SFSafariViewController(url: URL(string: "https://example.com")!)
        present(safari, animated: true, completion: nil)
    }
}
