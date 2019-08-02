//

import UIKit

class CustomFramePresentation: UIPresentationController {
    private var newFrame: ((UIView) -> CGRect)?
    private var savedFrame: CGRect?
    
    convenience init(presented: UIViewController, presenting: UIViewController?, frameInContainer: ((UIView) -> CGRect)?) {
        self.init(presentedViewController: presented, presenting: presenting)
        newFrame = frameInContainer
    }
    
    // MARK: - helpers
    
    func frameInContainer(_ frame: @escaping (UIView) -> CGRect, animate: Bool) {
        newFrame = frame
        invalidateFrame()
    }
    
    func invalidateFrame() {
        savedFrame = nil
    }
    
    func layoutPresented(animated: Bool, duration: TimeInterval = 1, options: UIView.AnimationOptions = []) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            })
        }
        else {
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
    }
    
    // MARK: - layout
    
    override func containerViewWillLayoutSubviews() {
        layoutPresented(animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateFrame()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        if let saved = savedFrame {
            return saved
        }
        if let container = containerView {
            savedFrame = newFrame?(container)
        }
        return savedFrame ?? .zero
    }
}
