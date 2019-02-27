import Foundation

private let privateKey = "d5aaf682f856e3668f0ac674484c3373fb790f9e"
private let publicKey = "a63d192034338073fa3c6f3d8ac2342f"
private let baseURL = "https://gateway.marvel.com/v1/public"

protocol RequestType {
    associatedtype ResponseType: Codable
    var endpoint: String { get }
    var options: [String] { get }
}

extension RequestType {
    var url: URL {
        let finalEndpoint = options.reduce(endpoint) { acc, opt in
            return acc + "&" + opt
        }

        return urlFromEndpoint(finalEndpoint)
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
