import Foundation

struct AppEnvironment {
    private static var environments = [Environment()]

    static var current: Environment {
        if let environment = environments.last { return environment }
        let environment = Environment()
        environments = [environment]

        return environment
    }

    static func pushEnvironment(_ environment: Environment) {
        environments.append(environment)
    }

    static func pushEnvironment(api: APIType = current.api,
                                favorites: FavoritesServiceType = current.favorites) {
        environments.append(Environment(api: api,
                                        favorites: favorites))
    }

    @discardableResult
    static func popEnvironment() -> Environment? {
        return environments.popLast()
    }
}
