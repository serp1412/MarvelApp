import Foundation
@testable import MarvelApp
import SnapshotTesting
import XCTest

class ActionSheetTests: XCTestCase {
    let container = UIViewController()

    @discardableResult
    func showSheet(
        actions: [DefaultActionView] = ActionSheetTestsConstants.defaultActions,
        maxHeight: CGFloat = 500,
        header: ActionSheetConfiguration.Header = .title("Header Title"),
        footer: UIView? = nil
    ) -> UIViewController {
        let actionSheet = ActionSheet(configuration: .init(
            header: header,
            footer: footer,
            maxHeight: maxHeight
        ))
        actionSheet.setActions(actions)
        actionSheet.present(in: container)

        return container
    }

    override func setUp() {
        super.setUp()
        let window = UIApplication.shared.windows[0]
        window.rootViewController = container
        container.view.backgroundColor = .red
    }

    func testBasicActionSheet() {
        // when
        let sheet = showSheet()

        // then
        let result = verifySnapshot(matching: sheet,
                                    as: .windowedImage,
                                    testName: name)
        XCTAssertNil(result)
    }

    func testCustomTitleActionSheet() {
        // when

        let sheet = showSheet(header: .view(ActionSheetTestsConstants.customHeader))

        // then
        let result = verifySnapshot(matching: sheet,
                                    as: .windowedImage,
                                    testName: name)
        XCTAssertNil(result)
    }

    func testMaxHeightLimitedActionSheet() {
        // when
        let sheet = showSheet(maxHeight: 200)

        // then
        let result = verifySnapshot(matching: sheet,
                                    as: .windowedImage,
                                    record: false,
                                    testName: name)
        XCTAssertNil(result)
    }

    func testFooterActionSheet() {
        // when
        let button = UIButton(type: .system)
        button.setTitle("Awesome Action!", for: .normal)
        let footer = UIView()
        footer.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        let sheet = showSheet(footer: footer)

        // then
        let result = verifySnapshot(matching: sheet,
                                    as: .windowedImage,
                                    record: false,
                                    testName: name)
        XCTAssertNil(result)
    }
}

enum ActionSheetTestsConstants {
    static let defaultActions: [DefaultActionView] = [
            .init(title: "First Action",
                  icon: .icon(.init(imageLiteralResourceName: "star"), size: 24),
                  rightTitle: "Disclaimer"),
            .init(title: "Second Action",
                  icon: .empty),
            .init(title: "Last Action",
                  icon: .empty),
    ]

    static let customHeader: UIView = {
        let icon = UIImageView()
        icon.image = .init(imageLiteralResourceName: "star")
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }

        let label = UILabel()
        label.text = "I'm Custom"

        let customTitle = UIStackView(arrangedSubviews: [icon, .spacer(.width(10)), label])

        return customTitle
    }()
}
