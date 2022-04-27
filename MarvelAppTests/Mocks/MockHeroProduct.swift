@testable import MarvelApp

extension HeroProduct: MockableModel {
    static func mocked() -> HeroProduct {
        return mocked(title: "Some Product")
    }

    static func mocked(title: String = "Some Product",
                       description: String? = nil,
                       thumbnail: Thumbnail? = .mocked()) -> HeroProduct {
        return .init(title: title,
                     description: description,
                     thumbnail: thumbnail)
    }
}
