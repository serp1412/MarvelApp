import Foundation

struct ComicsRequest: RequestType {
    typealias ResponseType = APICollection<HeroProduct>
    let endpoint: String = "/comics?"
    let options: [String]

    enum Options {
        case heroId(Int)
        case limit(Int)

        var string: String {
            switch self {
            case .limit(let limit): return "limit=\(limit)"
            case .heroId(let id): return "characters=\(id)"
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
