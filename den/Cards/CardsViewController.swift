//

import UIKit

class CardsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let items = 100.times { "Item \($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = CardsLayout(dataSource: self)
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
}

extension CardsViewController: CardsLayoutDataSource {
    func exposedHeightForCell(at: IndexPath) -> CGFloat {
        return 100
    }
    
    func heightForCell(at: IndexPath) -> CGFloat {
        return 600
    }
}

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardsCell.self), for: indexPath) as! CardsCell
        cell.label.text = items[indexPath.item]
        return cell
    }
}
