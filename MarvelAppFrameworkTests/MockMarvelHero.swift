@testable import MarvelAppFramework

extension MarvelHero: MockableModel {
    static func mocked() -> MarvelHero {
        return mocked(name: "Hulk")
    }

    static func mocked(name: String = "Hulk", description: String = "He smashes", thumbnail: Thumbnail = .mocked()) -> MarvelHero {
        return .init(name: name,
                     description: description,
                     thumbnail: thumbnail)
    }
}
