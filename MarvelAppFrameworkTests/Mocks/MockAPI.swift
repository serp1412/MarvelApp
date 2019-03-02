@testable import MarvelAppFramework

class MockAPI: APIType {
    var getHeroesStub = ClosureStub<Result<APICollection<MarvelHero>>>.doNotCall
    var getHeroesFuncCheck = FuncCheck<(String?, Int)>()
    func getHeroes(name: String?, offset: Int, completion: @escaping (Result<APICollection<MarvelHero>>) -> ()) {
        getHeroesFuncCheck.call((name, offset))
        getHeroesStub.call(completion)
    }
}
