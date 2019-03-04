@testable import MarvelAppFramework

class MockFavoritesService: FavoritesServiceType {
    var isFavoriteHeroWithIdFuncCheck = StubbableFuncCheck<Int, Bool>(stub: false)
    func isFavoriteHeroWithId(_ id: Int) -> Bool {
        isFavoriteHeroWithIdFuncCheck.call(id)
        return isFavoriteHeroWithIdFuncCheck.stub
    }

    var addHeroWithIdFuncCheck = FuncCheck<Int>()
    func addHeroWithId(_ id: Int) {
        addHeroWithIdFuncCheck.call(id)
    }

    var removeHeroWithIdFuncCheck = FuncCheck<Int>()
    func removeHeroWithId(_ id: Int) {
        removeHeroWithIdFuncCheck.call(id)
    }

    var synchronizeFuncCheck = ZeroArgumentsFuncCheck()
    func synchronize() {
        synchronizeFuncCheck.call()
    }

    var toggleWithIdFuncCheck = FuncCheck<Int>()
    func toggleWithId(_ id: Int) {
        toggleWithIdFuncCheck.call(id)
    }
}
