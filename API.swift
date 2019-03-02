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
        let request: ComicsRequest = .init(options: .heroId(heroId), limit > 0 ? .limit(limit) : nil)

        perform(request: request, completion: completion)
    }

    func getEvents(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        let request: EventsRequest = .init(options: .heroId(heroId), limit > 0 ? .limit(limit) : nil)

        perform(request: request, completion: completion)
    }

    func getStories(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        let request: StoriesRequest = .init(options: .heroId(heroId), limit > 0 ? .limit(limit) : nil)

        perform(request: request, completion: completion)
    }

    func getSeries(heroId: Int, limit: Int = 0, completion: @escaping (Result<APICollection<HeroProduct>>) -> ()) {
        let request: SeriesRequest = .init(options: .heroId(heroId), limit > 0 ? .limit(limit) : nil)

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
