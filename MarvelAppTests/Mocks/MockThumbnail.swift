@testable import MarvelApp

extension Thumbnail {
    static func mocked(path: String = "to/nowhere", extension: String = "jpg") -> Thumbnail {
        return .init(path: path, extension: `extension`)
    }
}
