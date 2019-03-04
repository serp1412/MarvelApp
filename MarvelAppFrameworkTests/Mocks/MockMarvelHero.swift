@testable import MarvelAppFramework

extension MarvelHero: MockableModel {
    static func mocked() -> MarvelHero {
        return mocked(name: "Hulk")
    }

    static func mocked(id: MarvelHero.Id = 1234, name: String = "Hulk", description: String = "He smashes", thumbnail: Thumbnail = .mocked()) -> MarvelHero {
        return .init(id: id,
                     name: name,
                     description: description,
                     thumbnail: thumbnail)
    }
}
