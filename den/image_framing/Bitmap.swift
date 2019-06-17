//

import Foundation

protocol Bitmap2D {
    associatedtype Value
    
    subscript(x: Int, y: Int) -> Value { get set }
    var width: Int { get }
    var height: Int { get }
}
