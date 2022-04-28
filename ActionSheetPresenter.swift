import UIKit

///
/// `ActionSheetPresenter` is a subcall of `UIPresentationController` that takes care of the
/// presentation logic of the `ActionSheet`
///
public class ActionSheetPresenter: UIPresentationController {
    let backdropView: UIView!
    let configuration: ActionSheetConfiguration

    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
        configuration.dismissCallback?()
    }

    public init(presentedViewController: UIViewController,
                presenting presentingViewController: UIViewController?,
                configuration: ActionSheetConfiguration) {
        self.configuration = configuration
        backdropView = UIView()
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backdropView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backdropView.isUserInteractionEnabled = true
        backdropView.addGestureRecognizer(tapGestureRecognizer)
        backdropView.backgroundColor = .black.withAlphaComponent(0.8)

    }

    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else { return .zero }

        let safeAreaFrame = containerView.bounds
            .inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width
        if let maxWidth = configuration.maxWidth {

            let fittingSize = CGSize(
                width: targetWidth,
                height: UIView.layoutFittingCompressedSize.height
            )
            let tempSize = presentedView.systemLayoutSizeFitting(fittingSize,
                                                                 withHorizontalFittingPriority: .defaultLow,
                                                                 verticalFittingPriority: .defaultLow)
            let contentSize = CGSize(width: min(tempSize.width, maxWidth),
                                     height: min(tempSize.height, configuration.maxHeight))
            let originX = floor((containerView.frame.width - contentSize.width) * 0.5)

            return CGRect(
                x: originX,
                y: containerView.frame.height - contentSize.height,
                width: contentSize.width,
                height: contentSize.height
            )

        } else {
            let fittingSize = CGSize(
                width: targetWidth,
                height: UIView.layoutFittingCompressedSize.height
            )
            let contentHeight = presentedView.systemLayoutSizeFitting(
                fittingSize, withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow).height
            let targetHeight = min(contentHeight, configuration.maxHeight)

            return CGRect(
                x: 0,
                y: containerView.frame.height - targetHeight,
                width: containerView.frame.width,
                height: targetHeight
            )
        }
    }

    public override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            self.backdropView.alpha = 0,
            completion: self.backdropView.removeFromSuperview()
        )
    }

    public override func presentationTransitionWillBegin() {
        backdropView.alpha = 0
        containerView?.addSubview(backdropView)
        presentedViewController.transitionCoordinator?.animate(
            self.backdropView.alpha = 1
        )
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        switch configuration.roundCornerStyle {
        case .topCorner:
            presentedView?.layer.cornerRadius = 8
            presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        default:
            presentedView?.layer.masksToBounds = true
            presentedView?.layer.cornerRadius = 8
        }
    }

    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backdropView.frame = containerView?.bounds ?? .zero
    }

    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        UIView.animate(withDuration: ActionSheetConstants.animationDuration) {
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }
        super.preferredContentSizeDidChange(forChildContentContainer: container)
    }
}
