//

import Foundation

protocol FSM {
    associatedtype State: Hashable
    associatedtype Input
    
    static var initialState: State { get }
    static var acceptingStates: Set<State> { get }
    static func transition(_: State, using: Input) -> State
}
