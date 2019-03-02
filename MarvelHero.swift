struct MarvelHero: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension MarvelHero: Equatable {}
