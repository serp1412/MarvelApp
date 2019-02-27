import Foundation

struct HeroListRequest: RequestType {
    typealias ResponseType = MarvelHero
    let endpoint: String = "/characters?orderBy=name"
    let options: [String]

    enum Options {
        case name(String)
        case nameStartsWith(String)

        var string: String {
            switch self {
            case .name(let name): return "name=\(name)"
            case .nameStartsWith(let prefix): return "nameStartsWith=\(prefix)"
            }
        }
    }

    init(options: [Options] = []) {
        self.options = options.map { $0.string }
    }

    init(options: Options?...) {
        self.options = options.compactMap { $0?.string }
    }
}
