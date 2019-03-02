import Foundation

enum ImageType {
    case portrait
    case landscape
    case square
    case fullsize

    var string: String {
        switch self {

        case .portrait: return "/portrait_fantastic"
        case .landscape: return "/landscape_xlarge"
        case .square: return "/standard_xlarge"
        case .fullsize: return ""
        }
    }
}

struct Thumbnail: Codable {
    private let path: String
    private let `extension`: String

    func url(for type: ImageType = .square) -> URL {
        let urlString = path + type.string + "." + self.extension
        return URL(string: urlString)!
    }

    init(path: String, extension: String) {
        self.path = path
        self.extension = `extension`
    }
}

extension Thumbnail: Equatable {}
