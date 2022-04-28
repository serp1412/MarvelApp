import Foundation
import RxSwift
import RxCocoa
import SnapKit

///
/// We are creating a custom action sheet that mimcs UIAlertController api and displays a column of elements
///
/// In order to create an action sheet you start by initializing it with its configuration (i.e. `ActionSheetConfiguration`)
///
/// `let actionSheet = ActionSheet(configuration: .init(header: .title("Title"), maxHeight: 400))`
///
///  Once you created it you might want to pass the action sheet some actions to display.
///  We have a default action sheet action for you to use however feel free to give it any array of `UIView`
///  elements that you need.
///
///  `actionSheet.setActions(myActions)`
///
///  or
///
///  `acitonSheet.setActions([DefaultActionView(title: "Title", icon: .icon(.add))])`
///
///  After the actions are added, you only have to present the action sheet on a target view controller like so:
///  `actionSheet.present(in: vc)`
///
///  In order to add or remove actions after the action sheet is presented use any of the following functions:
///  `actionSheet.setActions`, `actionSheet.removeAction`, `actionSheet.addAction`
///
///  If you want to add an action at a specific index, use the `addAction` function and pass it the optional
///  2nd parameter, in case you want to add it at the end of the actions list, you can use the public `actions`
///  variable to get the final index.
///
///  The action sheet will even animate the change of actions if their total height changes
///
///  More information on how to configure the action sheet can be found in the
///  `ActionSheetConfiguration` docs
///
public class ActionSheet: UIViewController {
    // MARK: - Properties

    #if !os(tvOS)
        override public var shouldAutorotate: Bool {
            return true
        }

        override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return self.presentingViewController?.supportedInterfaceOrientations ?? .portrait
        }

        override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
            return presentingViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        }
    #endif

    ///
    /// Main configuration point for the action sheet. Read-only
    ///
    public let configuration: ActionSheetConfiguration

    ///
    /// Actions property that allows you to see what actions are displayed or how many of them are there.
    /// Read-only
    ///
    ///
    public var actionViews: [UIView] {
        return actionsStack.arrangedSubviews
    }

    private lazy var appearanceDelegate: ActionSheetTransitionDelegate = {
            .init(configuration: self.configuration)
    }()

    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical

        return stack
    }()

    private let disposeBag = DisposeBag()

    // MARK: - Public methods

    ///
    /// Main initializer function. Pass it a `ActionSheetConfiguration` to get the instance
    ///
    /// - Parameters :
    ///    - configuration: main configuration file for the action sheet
    ///
    public init(configuration: ActionSheetConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = appearanceDelegate
        modalPresentationStyle = .custom
    }

    public required init?(coder aDecoder: NSCoder) {
        configuration = .empty
        super.init(coder: aDecoder)
    }

    ///
    /// Use this to setup your actions. You can use `DefaultActionView` for convenience or pass your
    /// own views.
    ///
    /// For your actions it's a good idea to provide a horizontal 20 px padding as it is added to the header
    /// automatically in accordance to our design.
    ///
    /// Will trigger action sheet frame recalculation
    ///
    /// - Parameters :
    ///    - actions: an array of views that will be displayed in a column setup and stretched to screen width
    ///
    public func setActions(_ actions: [UIView]) {
        actionsStack.arrangedSubviews.forEach({ self.actionsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        actions.forEach { self.actionsStack.addArrangedSubview($0) }

        presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }

    ///
    /// Use this to present the action sheet on your target view controller. Make sure you've setup the actions
    ///
    /// - Parameters :
    ///    - vc: `UIViewController` instance that will present our action sheet
    ///
    public func present(in vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
    }

    ///
    /// Use this to add actions separately. You can call it before or after presenting the action sheet.
    /// It adds the actions in reverse order to an array for example, i.e. the last item added will be on top
    ///
    ///  - Parameters :
    ///     - action: a view that will be added to the action sheet list of actions
    ///     - index: index of where to place the new action.  Default is 0 which adds it at the top.
    ///
    /// Will trigger action sheet frame recalculation
    ///
    public func addAction(_ action: UIView, at index: Int? = 0) {
        if let index = index {
            actionsStack.insertArrangedSubview(action, at: index)
        } else {
            actionsStack.addArrangedSubview(action)
        }

        presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }

    ///
    /// Use this to remove actions. You can call it before or after presenting the action sheet
    ///
    ///  - Parameters :
    ///     - action: the action that you want to be removed from the actions list
    ///
    /// Will trigger action sheet frame recalculation
    ///
    public func removeAction(_ action: UIView) {
        actionsStack.removeArrangedSubview(action)
        action.removeFromSuperview()
        presentationController?.preferredContentSizeDidChange(forChildContentContainer: self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = configuration.backgroundColor
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        view.addSubview(mainStack)
        var offset: CGFloat = 0
        if let safeAreaLayoutGuideBottomOffset = configuration.safeAreaLayoutGuideBottomOffset {
            offset = safeAreaLayoutGuideBottomOffset
        }
        mainStack.snp.makeConstraints { make in
            make.top.right.left.equalTo(self.view)
            if self.configuration.shouldContentStretchToBottom {
                make.bottom.equalToSuperview()
            } else {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(offset)
            }
        }

        let closeButton = UIButton(type: .custom)
        closeButton.setImage(ActionSheetConstants.closeIcon,
                             for: .normal)

        closeButton.rx.tap.subscribe { [weak self] _ in
            self?.dismissSheet()
        }.disposed(by: disposeBag)

        let headerStack = UIStackView(arrangedSubviews: [configuration.header.toView(), closeButton])
        headerStack.distribution = .equalSpacing
        headerStack.alignment = .top

        let headerView = UIView()
        headerView.addSubview(headerStack)
        headerView.backgroundColor = .clear
        mainStack.addArrangedSubview(headerView)
        headerStack.snp.makeConstraints { make in
            make.left.right.equalTo(headerView).inset(configuration.horizontalPadding)
            make.top.bottom.equalTo(headerView).inset(ActionSheetConstants.verticalPadding)
        }

        mainStack.addArrangedSubview(separator())

        let scrollView = UIScrollView()
        scrollView.addSubview(actionsStack)
        actionsStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView).priority(.medium)
        }

        mainStack.addArrangedSubview(scrollView)

        guard let footer = configuration.footer else { return }

        if !configuration.footerSeparatorHidden {
            mainStack.addArrangedSubview(separator())
        }
        mainStack.addArrangedSubview(footer)
    }

    @objc public func dismissSheet(completion: @escaping () -> Void = { }) {
        dismiss(animated: true, completion: completion)
        configuration.dismissCallback?()
    }

    private func separator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = configuration.separatorColor
        let separatorContainer = UIView()
        separatorContainer.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(ActionSheetConstants.separatorHeight)
            make.left.right.equalTo(separatorContainer).inset(ActionSheetConstants.horizontalPadding)
        }

        return separatorContainer
    }
}

extension ActionSheetConfiguration {
    static let empty: Self = .init(
        header: .view(UIView()),
        maxHeight: 0,
        backgroundColor: .white,
        separatorColor: .white,
        closeIconColor: .white
    )
}
