struct MarvelHero: Codable {
    typealias Id = Tagged<MarvelHero, Int>
    let id: Id
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension MarvelHero: Equatable {}
