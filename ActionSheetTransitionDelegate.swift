import UIKit

///
/// `ActionSheetTransitionDelegate` is used to take care of the presentation and animation setup for `ActionSheet`
///
public class ActionSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let configuration: ActionSheetConfiguration

    public init(configuration: ActionSheetConfiguration) {
        self.configuration = configuration
    }

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return ActionSheetPresenter(presentedViewController: presented,
                                      presenting: presenting,
                                      configuration: configuration)
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ActionSheetAnimator(isPresentation: true)
    }

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ActionSheetAnimator(isPresentation: false)
    }
}
