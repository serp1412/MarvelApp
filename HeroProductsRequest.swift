import Foundation

struct HeroProductsRequest: RequestType {
    typealias ResponseType = APICollection<HeroProduct>
    let endpoint: String
    let options: [String]

    enum Kind: CaseIterable {
        case comics
        case series
        case stories
        case events

        var endpoint: String {
            switch self {
            case .comics: return "/comics?"
            case .series: return "/series?"
            case .stories: return "/stories?"
            case .events: return "/events?"
            }
        }
    }

    enum Options {
        case heroId(MarvelHero.Id)
        case limit(Int)

        var string: String {
            switch self {
            case .limit(let limit): return "limit=\(limit)"
            case .heroId(let id): return "characters=\(id)"
            }
        }
    }

    init(kind: Kind, options: [Options] = []) {
        self.endpoint = kind.endpoint
        self.options = options.map { $0.string }
    }

    init(kind: Kind, options: Options?...) {
        self.endpoint = kind.endpoint
        self.options = options.compactMap { $0?.string }
    }
}
