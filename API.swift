import Foundation

protocol APIType {
    func getHeroes(name: String?, offset: Int, completion: @escaping (Result<APICollection<MarvelHero>>) -> ())
}

extension APIType {
    func getHeroes(name: String? = nil, offset: Int = 0, completion: @escaping (Result<APICollection<MarvelHero>>) -> ()) {
        getHeroes(name: name, offset: offset, completion: completion)
    }
}

class API: APIType {
    func getHeroes(name: String?, offset: Int, completion: @escaping (Result<APICollection<MarvelHero>>) -> ()) {
        let request: HeroListRequest = .init(options: name.flatMap(HeroListRequest.Options.name), .offset(offset))

        perform(request: request, completion: completion)
    }

    func getComics(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        getHeroProducts(kind: .comics, heroId: heroId, completion: completion)
    }

    func getEvents(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        getHeroProducts(kind: .events, heroId: heroId, completion: completion)
    }

    func getStories(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        getHeroProducts(kind: .stories, heroId: heroId, completion: completion)
    }

    func getSeries(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        getHeroProducts(kind: .series, heroId: heroId, completion: completion)
    }

    private func getHeroProducts(kind: HeroProductsRequest.Kind, heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        let request: HeroProductsRequest = .init(kind: kind, options: .heroId(heroId), limit > 0 ? .limit(limit) : nil)

        perform(request: request, completion: completion)
    }

    private func perform<R: RequestType>(request: R,
                                         completion: @escaping (Result<R.ResponseType>) -> ()) {
        URLSession.shared.dataTask(with: request.url) { (data, _, _) in
            guard let data = data,
                let response = try? JSONDecoder().decode(APIResponse<R.ResponseType>.self,
                                                         from: data)  else { return callOnMain(completion,
                                                                                               with: .failure) }
            callOnMain(completion,
                       with: .success(response.data))
            }.resume()
    }
}

private func callOnMain<T>(_ completion: @escaping (Result<T>) -> (),
                           with result: Result<T>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
