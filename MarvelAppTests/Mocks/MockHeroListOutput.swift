@testable import MarvelApp

class MockHeroListOutput: HeroListOutput {
    var view: HeroListInput!

    let mockHeroes: [MarvelHero] = [
            .mocked(),
            .mocked(),
            .mocked(),
            .mocked()
    ]

    var shouldShowFooter: Bool {
        false
    }

    var numberOfHeroes: Int {
        mockHeroes.count
    }

    func viewDidLoad() { }

    func viewDidAppear() { }

    func willDisplayCellAtIndex(_ index: Int) { }

    func heroForIndex(_ index: Int) -> MarvelHero {
        mockHeroes[index]
    }

    func searchBarDidEndEditingWithText(_ text: String?) { }

    func willDismissSearch() { }
}
