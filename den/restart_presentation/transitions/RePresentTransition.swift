//

import UIKit

enum RePresentTransitionState {
    case presented
    case dismissing
    case dismissed
    case presenting
}

enum RePresentTransitionInput {
    case start
    case finish
    case cancel
}

protocol RePresentTransition: AnyObject {
    var state: RePresentTransitionState { get set }
    var cancelled: Bool { get set }
    func perform(using: UIViewControllerContextTransitioning)
    func duration(using: UIViewControllerContextTransitioning?) -> TimeInterval
}

extension RePresentTransition {
    func stateTransition(_ input: RePresentTransitionInput) {
        switch (state, input) {
        case (.presented, .start):
            state = .dismissing
        case (.dismissed, .start):
            state = .presenting
        case (.dismissing, .finish):
            state = .dismissed
        case (.presenting, .finish):
            state = .presented
        case (.dismissing, .cancel):
            state = .presented
        case (.presenting, .cancel):
            state = .dismissed
        default:
            preconditionFailure("undefined transition state")
        }
        cancelled = input == .cancel
    }
}
