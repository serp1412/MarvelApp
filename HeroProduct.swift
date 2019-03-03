import Foundation

struct HeroProduct: Codable {
    let title: String
    let description: String?
    let thumbnail: Thumbnail?
}

extension HeroProduct: Equatable {}
