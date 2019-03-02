struct MarvelHero: Codable {
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension MarvelHero: Equatable {}
