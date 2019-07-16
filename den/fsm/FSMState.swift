//

import Foundation

protocol FSMState: Hashable {
    associatedtype Input
    
    static var initialState: Self { get }
    static var acceptingStates: Set<Self> { get }
    func transition(using: Input) -> Self
}

extension FSMState {
    var accepted: Bool {
        return Self.acceptingStates.contains(self)
    }
}
