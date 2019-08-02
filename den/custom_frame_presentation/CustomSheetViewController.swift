//

import UIKit

class CustomSheetSegue: UIStoryboardSegue {
    override func perform() {
        let dest = destination as! CustomSheetViewController
        dest.modalPresentationStyle = .custom
        dest.transitioningDelegate = dest
        source.present(dest, animated: true)
    }
}

class CustomSheetViewController: UIViewController {
    var size: CGFloat = 300
    
    @IBAction func dismiss() {
        dismiss(animated: true)
    }
    
    @IBAction func change(_ sender: UISlider) {
        size = CGFloat(sender.value)
        if let p = presentationController as? CustomSheetPresentation {
            p.invalidateFrame()
            p.layoutPresented(animated: true)
        }
    }
    
    @IBAction func endEditing(_ sender: UITextField) {
        sender.endEditing(true)
    }
}

extension CustomSheetViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let p = CustomSheetPresentation(presented: presented, presenting: presenting) { container in
            let container = container.bounds.size
            return CGRect(x: (container.width - self.size) / 2,
                          y: (container.height - self.size) / 2,
                          width: self.size,
                          height: self.size)
        }
        return p
    }
}
