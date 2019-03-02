@testable import MarvelAppFramework

class MockHeroListOutput: HeroListOutput {
    var shouldShowFooterStub: Bool = false
    var shouldShowFooter: Bool {
        return shouldShowFooterStub
    }

    var numberOfHeroesStub: Int = 0
    var numberOfHeroes: Int {
        return numberOfHeroesStub
    }

    var viewDidLoadFuncCheck = ZeroArgumentsFuncCheck()
    func viewDidLoad() {
        viewDidLoadFuncCheck.call()
    }

    var willDisplayCellAtIndexFuncCheck = FuncCheck<Int>()
    func willDisplayCellAtIndex(_ index: Int) {
        willDisplayCellAtIndexFuncCheck.call(index)
    }


    var heroForIndexFuncCheck = FuncCheck<Int>()
    func heroForIndex(_ index: Int) -> MarvelHero {
        heroForIndexFuncCheck.call(index)

        return .mocked()
    }

    var searchBarDidEndEditingWithTextFuncCheck = FuncCheck<String?>()
    func searchBarDidEndEditingWithText(_ text: String?) {
        searchBarDidEndEditingWithTextFuncCheck.call(text)
    }

    var willDismissSearchFuncCheck = ZeroArgumentsFuncCheck()
    func willDismissSearch() {
        willDismissSearchFuncCheck.call()
    }
}
