//

import UIKit

class CustomSheetPresentation: CustomFramePresentation {
    var keyboardFrame = CGRect.zero
    
    // MARK: - helpers
    
    private let dimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 13
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
    
    private var observeNotifications = false {
        didSet {
            if observeNotifications == oldValue {
                return
            }
            if observeNotifications {
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(keyboardWillChange),
                                                       name: UIWindow.keyboardWillChangeFrameNotification,
                                                       object: nil)
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(keyboardWillChange),
                                                       name: UIWindow.keyboardWillHideNotification,
                                                       object: nil)
            }
            else {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    @objc func keyboardWillChange(n: Notification) {
        if n.name == UIWindow.keyboardWillChangeFrameNotification {
            keyboardFrame = n.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        }
        else {
            keyboardFrame = .zero
        }
        let duration = n.userInfo?[UIWindow.keyboardAnimationDurationUserInfoKey] as? Double ?? 1
        let options = (n.userInfo?[UIWindow.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve)?.animationOption ?? []
        layoutPresented(animated: true, duration: duration, options: options)
    }
    
    // MARK: - layout
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView!.bounds
        presentedViewController.view.frame = wrapperView.bounds
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let frame = super.frameOfPresentedViewInContainerView
        let top = containerView?.safeAreaInsets.top ?? 0
        let offset = keyboardFrame.minY - keyboardFrame.maxY
        let dy = max(offset, top - frame.minY)
        return frame.offsetBy(dx: 0, dy: dy)
    }
    
    // MARK: - transition
    
    override func presentationTransitionWillBegin() {
        containerView!.addSubview(dimmingView)
        wrapperView.addSubview(presentedViewController.view)
        dim(true)
        observeNotifications = true
    }
    
    override func dismissalTransitionWillBegin() {
        dim(false)
        observeNotifications = false
    }
    
    // MARK: - adaptive presentation
    
    override func adaptivePresentationStyle(for traits: UITraitCollection) -> UIModalPresentationStyle {
        return traits.horizontalSizeClass == .compact ? .fullScreen : .none
    }
    
    // MARK: - add wrapper view
    
    override var presentedView: UIView? {
        return wrapperView
    }
}
