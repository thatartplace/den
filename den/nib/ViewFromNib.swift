//

import UIKit

class ViewFromNib: UIView {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var slider: UISlider!
    
    convenience init(frame: CGRect, slider: Float) {
        self.init(frame: frame)
        self.slider.value = slider
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ViewFromNib", owner: self, options: nil)
        self.addSubview(content)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("ViewFromNib", owner: self, options: nil)
        self.addSubview(content)
    }
}
