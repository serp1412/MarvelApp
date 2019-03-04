@testable import MarvelAppFramework

class MockAPI: APIType {
    var getHeroesStub = ClosureStub<Result<APICollection<MarvelHero>>>.doNotCall
    var getHeroesFuncCheck = FuncCheck<(String?, Int)>()
    func getHeroes(name: String?, offset: Int, completion: @escaping (Result<APICollection<MarvelHero>>) -> ()) {
        getHeroesFuncCheck.call((name, offset))
        getHeroesStub.call(completion)
    }

    var getHeroProductsFuncCheck = ClosureStubFuncCheck<(HeroProductsRequest.Kind, MarvelHero.Id, Int), Result<APICollection<HeroProduct>>>()
    func getHeroProducts(kind: HeroProductsRequest.Kind, heroId: MarvelHero.Id, limit: Int, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        let stub = getHeroProductsFuncCheck.call(with: (kind, heroId, limit))
        stub.call(completion)
    }
}
