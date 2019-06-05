//

import UIKit

protocol CardsLayoutDataSource: AnyObject {
    func exposedHeightForCell(at: IndexPath) -> CGFloat
    func heightForCell(at: IndexPath) -> CGFloat
}

struct CellAttributesInvariants {
    var size: CGSize
    var exposedHeight: CGFloat
    var stackedHeight: CGFloat
    var zIndex: Int
}

class CardsLayout: UICollectionViewLayout {
    weak var dataSource: CardsLayoutDataSource!
    var invariants: [CellAttributesInvariants] = []
    
    convenience init(dataSource: CardsLayoutDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
    var cView: UICollectionView {
        guard let collectionView = collectionView else {
            preconditionFailure("collectionView needs to be non nil")
        }
        return collectionView
    }
    
    override func prepare() {
        let count = cView.numberOfItems(inSection: 0)
        let indexPaths = count.times { IndexPath(item: $0, section: 0) }
        var stackedHeight: CGFloat = 0
        invariants = indexPaths.map { indexPath in
            let height = dataSource.heightForCell(at: indexPath)
            let exposed = dataSource.exposedHeightForCell(at: indexPath)
            stackedHeight += exposed
            return CellAttributesInvariants(size: CGSize(width: cView.bounds.width, height: height),
                                            exposedHeight: exposed,
                                            stackedHeight: stackedHeight,
                                            zIndex: indexPath.row)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: cView.bounds.width, height: invariants.last?.stackedHeight ?? 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var springDistance: CGFloat?
        let inRect = invariants.filter { invariant in
            if invariant.stackedHeight < rect.origin.y {
                return false
            }
            else {
                springDistance ?= invariant.stackedHeight - rect.origin.y
            }
            if invariant.stackedHeight > rect.origin.y + rect.height + invariant.exposedHeight {
                return false
            }
            return true
        }
        return inRect.enumerated().map { i, invariant in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.frame = CGRect(origin: CGPoint(x: 0, y: invariant.stackedHeight - invariant.exposedHeight),
                                      size: invariant.size)
            attributes.zIndex = invariant.zIndex
            return attributes
        }
    }
}
