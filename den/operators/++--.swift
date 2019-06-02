//

import Foundation

prefix operator ++
postfix operator ++
prefix operator --
postfix operator --

extension Int {
    @discardableResult
    static prefix func ++ (operand: inout Int) -> Int {
        operand += 1
        return operand
    }
    
    @discardableResult
    static postfix func ++ (operand: inout Int) -> Int {
        let old = operand
        operand += 1
        return old
    }
    
    @discardableResult
    static prefix func -- (operand: inout Int) -> Int {
        operand -= 1
        return operand
    }
    
    @discardableResult
    static postfix func -- (operand: inout Int) -> Int {
        let old = operand
        operand -= 1
        return old
    }
}
