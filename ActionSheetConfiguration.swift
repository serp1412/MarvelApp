import UIKit

///
/// `ActionSheetConfiguration` is used to configure the main parts of the `ActionSheet`
///
public struct ActionSheetConfiguration {
    public enum Header {
        case title(_ title: String, _ subtitle: String? = nil)
        case view(_ view: UIView)
        case empty
    }

    public enum RoundCornerStyle {
        case allCorner
        case topCorner
    }

    // MARK: - Properties
    public let maxHeight: CGFloat
    public let maxWidth: CGFloat?
    public let safeAreaLayoutGuideBottomOffset: CGFloat?
    public let header: Header
    public let footer: UIView?
    public let backgroundColor: UIColor
    public let separatorColor: UIColor
    public let footerSeparatorHidden: Bool
    public let closeIconColor: UIColor
    public let dismissCallback: (() -> Void)?
    public let roundCornerStyle: RoundCornerStyle
    public let shouldContentStretchToBottom: Bool
    public let horizontalPadding: CGFloat

    ///
    /// Main initializer function
    /// - Parameters :
    ///    - header: Instance of `Header` enum it is used to provide a default title for the action sheet.
    ///     Or a custom view that you can pass through the `.view(let view)` case.
    ///     Header content is inset by horizontal padding of 20px and vertical of 16px as per our design.
    ///    - footer: an optional view that will be placed beneath the list of actions and separated by a line separator if provided.
    ///    - maxHeight: a float value that will cap the height of how high the action sheet can grow.
    ///      In case the content size won't fit that value, the height will be enforced but the actions will become scrollable instead.
    ///    - backgroundColor: This property is used to configure the background color of the action sheet.
    ///    This is of the type `Color` which is our design token.
    ///    - separatorColor : This property is used to configure the color of the separator lines.
    ///    This is of the type `Color` which is our design token.
    ///    - footerSeparatorHidden : If `true` then separator above the footer will be hidden. `false` is a default.
    ///    - closeIconColor : This property is used to configure the color of the close icon in the header.
    ///    This is of the type `Color` which is our design token.
    ///    - maxWidth: nullable, setup the content width of action sheet.
    ///    - dismissCallback: nullable, called when action sheet is dismissed.
    ///    - roundCornerStyle: Allows you to set all or only top corners' radii
    ///    - shouldContentStretchToBottom: setting to false will set the content to to be over the bottom safe area, true will stretch it to bottom
    ///
    public init(header: Header,
                footer: UIView? = nil,
                maxHeight: CGFloat,
                backgroundColor: UIColor = .white,
                separatorColor: UIColor = .gray,
                footerSeparatorHidden: Bool = false,
                closeIconColor: UIColor = .gray,
                maxWidth: CGFloat? = nil,
                safeAreaLayoutGuideBottomOffset: CGFloat? = nil,
                dismissCallback: (() -> Void)? = nil,
                roundCornerStyle: RoundCornerStyle = .allCorner,
                isContentReachToBottom: Bool = false,
                horizontalPadding: CGFloat = ActionSheetConstants.horizontalPadding) {
        self.header = header
        self.footer = footer
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
        self.closeIconColor = closeIconColor
        self.maxHeight = maxHeight
        self.maxWidth = maxWidth
        self.safeAreaLayoutGuideBottomOffset = safeAreaLayoutGuideBottomOffset
        self.dismissCallback = dismissCallback
        self.footerSeparatorHidden = footerSeparatorHidden
        self.roundCornerStyle = roundCornerStyle
        self.shouldContentStretchToBottom = isContentReachToBottom
        self.horizontalPadding = horizontalPadding
    }
}

extension ActionSheetConfiguration.Header {
    public func toView() -> UIView {
        switch self {
        case .title(let title, let subtitle):
            let headerStack = UIStackView()
            headerStack.spacing = ActionSheetConstants.headerSpacing
            headerStack.axis = .vertical

            let titleLabel = UILabel()
            titleLabel.font = .systemFont(ofSize: ActionSheetConstants.headerTitleSize)
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            headerStack.addArrangedSubview(titleLabel)

            if let subtitle = subtitle, subtitle.count > 0 {
                let subtitleLabel = UILabel()
                subtitleLabel.font = .systemFont(ofSize: ActionSheetConstants.headerSubtitleSize)
                subtitleLabel.text = subtitle
                headerStack.addArrangedSubview(subtitleLabel)
            }

            return headerStack
        case .view(let view):
            return view
        case .empty:
            return UIView()
        }
    }
}
