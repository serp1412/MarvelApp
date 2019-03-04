import Foundation

protocol FavoritesServiceType {
    func isFavorite(_ id: MarvelHero.Id) -> Bool
    func addHero(with id: MarvelHero.Id)
    func removeHero(with id: MarvelHero.Id)
    func synchronize()
    func toggle(with id: MarvelHero.Id)
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

    fileprivate lazy var favorites: [MarvelHero.Id] = {
        let array = NSArray(contentsOf: plistURL) as? [Int] ?? []
        return array.map { .init(rawValue: $0) }
    }()

    func isFavorite(_ id: MarvelHero.Id) -> Bool {
        return favorites.contains(id)
    }

    func addHero(with id: MarvelHero.Id) {
        favorites.append(id)
    }

    func removeHero(with id: MarvelHero.Id) {
        favorites.removeAll(where: { $0 == id })
    }

    func toggle(with id: MarvelHero.Id) {
        isFavorite(id) ?
            removeHero(with: id) :
            addHero(with: id)
    }

    func synchronize() {
        (favorites.map({ $0.rawValue }) as NSArray).write(to: plistURL, atomically: true)
    }
}
