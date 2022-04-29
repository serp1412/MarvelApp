import UIKit
import SnapKit

///
/// We are creating a default action to cover the basic use case of our `ActionSheet`
///
/// It's represented by a horizontal layout of an Icon view, a main title label and on the trailing side an optional secondary label
///
public class DefaultActionView: UIView {

    // MARK: - Properties
    public let title: String
    public let icon: Icon
    public var rightTitle: String? {
        didSet {
            rightLabel.text = oldValue
        }
    }
    private let onTap: () -> Void
    private var rightLabel: UILabel!
    private weak var actionSheet: ActionSheet?

    public enum Icon {
        case icon(_ icon: UIImage, size: CGFloat? = nil, color: UIColor? = nil)
        case view(_ view: UIView)
        case empty
    }

    ///
    /// Main initializer function.
    ///  - Parameters:
    ///     - title: a `String` instance that will be used to display in the main title label
    ///     - icon: a `Icon` instance that configures the leading UI element. It accepts either a custom `UIView` or a `UIImage` that will be presented in a `UIImageView`
    ///     - rightTitle: an optional `String` that will be displayed in the trailing side if provided.
    ///     - onTap: a closure that will be called if this action is tapped
    ///
    public init(title: String,
                icon: Icon,
                rightTitle: String? = nil,
                sheetToDismiss: ActionSheet? = nil,
                onTap: @escaping () -> Void = { }) {
        self.title = title
        self.icon = icon
        self.rightTitle = rightTitle
        self.onTap = onTap
        self.actionSheet = sheetToDismiss
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) {
        self.title = ""
        self.icon = .view(UIView())
        self.rightTitle = nil
        self.onTap = { }
        super.init(coder: coder)
    }

    private func setupUI() {
        let label = UILabel()
        label.font = .systemFont(ofSize: ActionSheetConstants.actionTitleSize)
        label.text = title

        rightLabel = UILabel()
        rightLabel.font = .systemFont(ofSize: ActionSheetConstants.actionDisclaimerSize)
        rightLabel.textColor = .lightGray
        rightLabel.text = rightTitle

        let leftStack = UIStackView(arrangedSubviews: [
            icon.toView(),
            .spacer(.width(ActionSheetConstants.smallSpacer)),
            label,
            UIView()
        ])
        let mainStack = UIStackView(arrangedSubviews: [
            leftStack,
            UIView(),
            rightLabel,
            .spacer(.width(ActionSheetConstants.bigSpacer))
        ])

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(ActionSheetConstants.horizontalPadding)
            make.top.bottom.equalTo(self).inset(ActionSheetConstants.verticalPadding)
        }

        let tap = UITapGestureRecognizer.init(target: self,
                                              action: #selector(onTapSelector))
        addGestureRecognizer(tap)
    }

    @objc private func onTapSelector() {
        if let sheetToDismiss = actionSheet {
            sheetToDismiss.dismissSheet()
        }
        onTap()
    }
}

public extension DefaultActionView.Icon {
    func toView() -> UIView {
        switch self {
        case .icon(let icon, let size, let color):
            let iconView = UIImageView()
            iconView.image = icon
            if let size = size {
                iconView.snp.makeConstraints { make in
                    make.width.height.equalTo(size)
                }
            }
            
            if let color = color {
                iconView.image = icon.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = color
            }

            return iconView

        case .view(let view):
            return view
        case .empty:
            return UIView()
        }
    }
}
