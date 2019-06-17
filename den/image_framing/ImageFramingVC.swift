//

import UIKit

class ImageFramingVC: UIViewController {
    @IBOutlet weak var framingView: ImageFramingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        framingView.image = UIImage(named: "intro1")
    }
}
