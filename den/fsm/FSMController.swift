//

import Foundation

struct FSMController<M: FSM> {
    typealias State = M.State
    typealias Input = M.Input
    typealias PreHandler = () -> Void
    typealias PostHandler = () -> Void
    typealias StateHandler = (State) -> Void
    
    private var state: State
    private var preHandlers: [State: [PreHandler]] = [:]
    private var postHandlers: [State: [PostHandler]] = [:]
    private let performState: StateHandler
    
    init(stateHandler: @escaping StateHandler) {
        state = M.initialState
        performState = stateHandler
    }
    
    mutating func input(_ input: Input) {
        state = M.transition(state, using: input)
        preHandlers[state]?.forEach { $0() }
        performState(state)
        postHandlers[state]?.forEach { $0() }
    }
    
    mutating func reset() {
        state = M.initialState
    }
    
    mutating func pre(_ state: State, handler: @escaping PreHandler) -> FSMController {
        var handlers = preHandlers[state] ?? []
        handlers.append(handler)
        preHandlers[state] = handlers
        return self
    }
    
    mutating func post(_ state: State, handler: @escaping PostHandler) -> FSMController {
        var handlers = postHandlers[state] ?? []
        handlers.append(handler)
        postHandlers[state] = handlers
        return self
    }
}
