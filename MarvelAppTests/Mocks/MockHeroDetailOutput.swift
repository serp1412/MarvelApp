import UIKit
@testable import MarvelApp

class MockHeroDetailOutput: HeroDetailOutput {
    var view: HeroDetailInput!

    var numberOfSections: Int {
        3
    }

    var hero: MarvelHero {
            .mocked()
    }

    func viewDidLoad() { }

    func numberOfItemsInSection(_ section: Int) -> Int {
        section == 0 ? 1 : 3
    }

    func cellTypeForSection(_ section: Int) -> DetailCellType {
        section == 0 ? .poster : .card
    }

    func product(at indexPath: IndexPath) -> HeroProduct {
            .mocked(title: "Some Product",
                    description: "A great description")
    }

    func titleForSection(_ section: Int) -> String {
        return "Comics"
    }

    func favoriteButtonTapped() { }
}
