//

import Foundation

extension Collection {
    func reduce<Item: AdditiveArithmetic>(_ repeated: (Element) -> Item) -> Item {
        return self.reduce(.zero) { $0 + repeated($1) }
    }
    
    func map<Item>(_ repeated: (Element) -> Item?) -> [Item] {
        return self.reduce(into: []) { a, e in
            if let item = repeated(e) {
                a.append(item)
            }
        }
    }
}

extension Collection where Element: AdditiveArithmetic {
    func reduce() -> Element {
        return self.reduce { $0 }
    }
}

extension Int {
    @discardableResult
    func times<Item>(_ repeated: (Int) -> Item) -> [Item] {
        let to = self > 0 ? self : 0
        return (0..<to).map(repeated)
    }
    
    func reduce<Item: AdditiveArithmetic>(_ repeated: (Int) -> Item) -> Item {
        let to = self > 0 ? self : 0
        return (0..<to).reduce(repeated)
    }
}
