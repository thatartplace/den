//

import UIKit

protocol CardsLayoutDataSource: AnyObject {
    func exposedHeightForCell(at: IndexPath) -> CGFloat
    func heightForCell(at: IndexPath) -> CGFloat
}

struct CellInvariants {
    var size: CGSize
    var exposedHeight: CGFloat
    var stackedHeight: CGFloat
    var index: Int
    
    var stackedBase: CGFloat {
        return stackedHeight - exposedHeight
    }
}

class CardsLayout: UICollectionViewLayout {
    weak var dataSource: CardsLayoutDataSource!
    var invariants: [CellInvariants] = []
    var contentSize = CGSize.zero
    
    convenience init(dataSource: CardsLayoutDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
    var cView: UICollectionView {
        guard let collectionView = collectionView else {
            preconditionFailure("calling layout methods before collectionView is set")
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
            return CellInvariants(size: CGSize(width: cView.bounds.width, height: height),
                                            exposedHeight: exposed,
                                            stackedHeight: stackedHeight,
                                            index: indexPath.item)
        }
        contentSize = CGSize(width: cView.bounds.width, height: stackedHeight)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minY = cView.contentOffset.y
        let maxY = cView.contentOffset.y + contentSize.height
        var springDistance: CGFloat?
        let inRect = invariants.filter { invariant in
            let top = invariant.stackedBase
            let bottom = invariant.stackedHeight
            if max(top, bottom, minY) == minY || min(top, bottom, maxY) == maxY {
                return false
            }
            else {
                springDistance ?= top - minY
            }
            return true
        }
        return inRect.map { invariant in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: invariant.index, section: 0))
            let origin = CGPoint(x: 0, y: max(invariant.stackedBase, minY))
            attributes.frame = CGRect(origin: origin, size: invariant.size)
            attributes.zIndex = invariant.index
            return attributes
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
