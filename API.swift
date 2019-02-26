import Foundation

private let privateKey = "d5aaf682f856e3668f0ac674484c3373fb790f9e"
private let publicKey = "a63d192034338073fa3c6f3d8ac2342f"
private let baseURL = "https://gateway.marvel.com/v1/public"

protocol APIType {
    func getHeroes(completion: @escaping (Result<[MarvelHero]>) -> ())
}

class API: APIType {
    func getHeroes(completion: @escaping (Result<[MarvelHero]>) -> ()) {
        let url = urlFromEndpoint("/characters?orderBy=name")

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                let response = try? JSONDecoder().decode(APIResponse<APICollection<MarvelHero>>.self,
                                                         from: data)  else { return callOnMain(completion,
                                                                                               with: .failure) }
            callOnMain(completion,
                       with:.success(response.data.results))
            }.resume()
    }

    private func urlFromEndpoint(_ endpoint: String) -> URL {
        return URL(string: baseURL + endpoint + urlPrefix)!
    }

    private var urlPrefix: String {
        let date = Date().string
        return "&ts=\(date)&hash=\(hashFromDate(date))&apikey=\(publicKey)"
    }

    private func hashFromDate(_ date: String) -> String {
        return (date + privateKey + publicKey).utf8.md5.rawValue
    }
}

extension Date {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"

        return formatter
    }()

    var string: String {
        return Date.formatter.string(from: self)
    }
}

private func callOnMain<T>(_ completion: @escaping (Result<T>) -> (),
                           with result: Result<T>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
