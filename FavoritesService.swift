import Foundation

protocol FavoritesServiceType {
    func isFavoriteHeroWithId(_ id: Int) -> Bool
    func addHeroWithId(_ id: Int)
    func removeHeroWithId(_ id: Int)
    func synchronize()
    func toggleWithId(_ id: Int)
}

class FavoritesService: FavoritesServiceType {
    fileprivate var plistURL: URL {
        let documentsURL = try! FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true)
        let path = documentsURL.appendingPathComponent("favorites.plist")
        if !FileManager.default.fileExists(atPath: path.relativePath) {
            NSArray().write(to: path, atomically: true)
        }

        return path
    }

    fileprivate lazy var favorites: [Int] = {
        return NSArray(contentsOf: plistURL) as? [Int] ?? []
    }()

    func isFavoriteHeroWithId(_ id: Int) -> Bool {
        return favorites.contains(id)
    }

    func addHeroWithId(_ id: Int) {
        favorites.append(id)
    }

    func removeHeroWithId(_ id: Int) {
        favorites.removeAll(where: { $0 == id })
    }

    func toggleWithId(_ id: Int) {
        isFavoriteHeroWithId(id) ?
            removeHeroWithId(id) :
            addHeroWithId(id)
    }

    func synchronize() {
        (favorites as NSArray).write(to: plistURL, atomically: true)
    }
}
