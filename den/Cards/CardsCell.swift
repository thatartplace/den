//

import UIKit

class CardsCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 15
    }
}
