import Foundation

protocol APIType {
    func getHeroes(name: String?, completion: @escaping (Result<[MarvelHero]>) -> ())
}

extension APIType {
    func getHeroes(name: String? = nil, completion: @escaping (Result<[MarvelHero]>) -> ()) {
        getHeroes(name: name, completion: completion)
    }
}

class API: APIType {
    func getHeroes(name: String?, completion: @escaping (Result<[MarvelHero]>) -> ()) {
        let request: HeroListRequest = .init(options: name.flatMap(HeroListRequest.Options.name))

        perform(request: request, completion: completion)
    }

    private func perform<R: RequestType>(request: R,
                                         completion: @escaping (Result<[R.ResponseType]>) -> ()) {
        URLSession.shared.dataTask(with: request.url) { (data, _, _) in
            guard let data = data,
                let response = try? JSONDecoder().decode(APIResponse<APICollection<R.ResponseType>>.self,
                                                         from: data)  else { return callOnMain(completion,
                                                                                               with: .failure) }
            callOnMain(completion,
                       with: .success(response.data.results))
            }.resume()
    }
}

private func callOnMain<T>(_ completion: @escaping (Result<T>) -> (),
                           with result: Result<T>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
