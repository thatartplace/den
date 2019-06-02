//

import Foundation

extension Collection {
    func reduce<Item: AdditiveArithmetic>(_ repeated: (Element) -> Item) -> Item {
        return self.reduce(.zero) { $0 + repeated($1) }
    }
    
    func till(_ stop: (Element) -> Bool) -> Element? {
        for e in self {
            if stop(e) {
                return e
            }
        }
        return nil
    }
}

extension Collection where Element: AdditiveArithmetic {
    func reduce() -> Element {
        return self.reduce { $0 }
    }
}

extension Int {
    func times<Item>(_ repeated: (Int) -> Item) -> [Item] {
        let to = self > 0 ? self : 0
        return (0..<to).map(repeated)
    }
    
    func reduce<Item: AdditiveArithmetic>(_ repeated: (Int) -> Item) -> Item {
        let to = self > 0 ? self : 0
        return (0..<to).reduce(repeated)
    }
}
