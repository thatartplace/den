//

import UIKit

class CustomSheetPresentation: CustomFramePresentation {
    // MARK: - helpers
    
    private let dimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private func dim(_ dim: Bool, animate: Bool = true) {
        let to: CGFloat = dim ? 0.5 : 0
        if animate, let coordinator = presentingViewController.transitionCoordinator {
            let from: CGFloat = dim ? 0 : 0.5
            dimmingView.alpha = from
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = to
            })
        }
        else {
            dimmingView.alpha = to
        }
    }
    
    // MARK: - layout
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView!.bounds
        presentedViewController.view.frame = wrapperView.bounds
    }
    
    // MARK: - transition
    
    override func presentationTransitionWillBegin() {
        containerView!.addSubview(dimmingView)
        wrapperView.addSubview(presentedViewController.view)
        dim(true)
    }
    
    override func dismissalTransitionWillBegin() {
        dim(false)
    }
    
    // MARK: - adaptive presentation
    
    override func adaptivePresentationStyle(for traits: UITraitCollection) -> UIModalPresentationStyle {
        return traits.horizontalSizeClass == .compact || traits.verticalSizeClass == .compact ? .fullScreen : .none
    }
    
    // MARK: - add wrapper view
    
    override var presentedView: UIView? {
        return wrapperView
    }
}
