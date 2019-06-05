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
    var index: Int
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
                                            index: indexPath.item)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: cView.bounds.width, height: invariants.last?.stackedHeight ?? 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var springDistance: CGFloat?
        let inRect = invariants.filter { invariant in
            if invariant.stackedHeight < rect.minY {
                return false
            }
            else {
                springDistance ?= invariant.stackedHeight - rect.minY
            }
            if invariant.stackedHeight > rect.maxY + invariant.exposedHeight {
                return false
            }
            return true
        }
        return inRect.map { invariant in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: invariant.index, section: 0))
            let origin = CGPoint(x: 0, y: invariant.stackedHeight - invariant.exposedHeight)
            attributes.frame = CGRect(origin: origin, size: invariant.size)
            attributes.zIndex = invariant.index
            return attributes
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
