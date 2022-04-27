import SnapshotTesting
import XCTest
@testable import MarvelApp

class HeroListSnapshotTests: XCTestCase {
    var heroListVC: HeroListViewController!
    var interactor: HeroListOutput!
    
    override func setUp() {
        heroListVC = HeroListViewController.instantiate()
        interactor = MockHeroListOutput()
        heroListVC.interactor = interactor
        interactor.view = heroListVC
    }
    
    func testHeroListSnapshot() {
        let navVC = UINavigationController.init(rootViewController: heroListVC)
        assertSnapshot(matching: navVC, as: .image)
      }
}
