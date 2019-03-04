@testable import MarvelAppFramework

class MockFavoritesService: FavoritesServiceType {
    var isFavoriteHeroWithIdFuncCheck = StubbableFuncCheck<MarvelHero.Id, Bool>(stub: false)
    func isFavorite(_ id: MarvelHero.Id) -> Bool {
        isFavoriteHeroWithIdFuncCheck.call(id)
        return isFavoriteHeroWithIdFuncCheck.stub
    }

    var addHeroWithIdFuncCheck = FuncCheck<MarvelHero.Id>()
    func addHero(with id: MarvelHero.Id) {
        addHeroWithIdFuncCheck.call(id)
    }

    var removeHeroWithIdFuncCheck = FuncCheck<MarvelHero.Id>()
    func removeHero(with id: MarvelHero.Id) {
        removeHeroWithIdFuncCheck.call(id)
    }

    var synchronizeFuncCheck = ZeroArgumentsFuncCheck()
    func synchronize() {
        synchronizeFuncCheck.call()
    }

    var toggleWithIdFuncCheck = FuncCheck<MarvelHero.Id>()
    func toggle(with id: MarvelHero.Id) {
        toggleWithIdFuncCheck.call(id)
    }
}
