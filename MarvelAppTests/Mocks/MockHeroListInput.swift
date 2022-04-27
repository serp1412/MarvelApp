@testable import MarvelApp

class MockHeroListInput: HeroListInput {
    var reloadDataFuncCheck = ZeroArgumentsFuncCheck()
    func reloadData() {
        reloadDataFuncCheck.call()
    }

    var showLoadingFuncCheck = ZeroArgumentsFuncCheck()
    func showLoading() {
        showLoadingFuncCheck.call()
    }

    var hideLoadingFuncCheck = ZeroArgumentsFuncCheck()
    func hideLoading() {
        hideLoadingFuncCheck.call()
    }
}
