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
    var compressEffectRange: CGFloat = 0
    
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
    
    var minY: CGFloat {
        return cView.contentOffset.y
    }
    
    var maxY: CGFloat {
        return cView.contentOffset.y + contentSize.height
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
        let inRect = invariants.filter { invariant in
            let top = invariant.stackedBase
            let bottom = invariant.stackedHeight
            return max(top, bottom, minY) != minY && min(top, bottom, maxY) != maxY
        }
        return inRect.map(attributesForCell)
    }
    
    func attributesForCell(invariant: CellInvariants) -> UICollectionViewLayoutAttributes {
        let offset = max(0, invariant.stackedBase - minY)
        let inRange = compressEffectRange - offset
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: invariant.index, section: 0))
        attributes.zIndex = invariant.index
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
