//

import UIKit

class ViewFromNibViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(ViewFromNib(frame: CGRect(x: 0, y: 200, width: 200, height: 200), slider: 0.8))
    }
}
