import SnapshotTesting
import XCTest
@testable import MarvelApp

class HeroDetailSnapshotTests: XCTestCase {
    var heroDetailVC: HeroDetailViewController!
    var interactor: HeroDetailOutput!

    override func setUp() {
        heroDetailVC = HeroDetailViewController.instantiate()
        interactor = MockHeroDetailOutput()
        heroDetailVC.interactor = interactor
        interactor.view = heroDetailVC
    }

    func testHeroDetailSnapshot() {
        let navVC = UINavigationController(rootViewController: heroDetailVC)
        assertSnapshot(matching: navVC, as: .image(size: .init(width: 375,
                                                               height: 2150)))
    }
}
