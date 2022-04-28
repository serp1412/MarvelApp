struct Environment {
    let api: APIType
    let favorites: FavoritesServiceType

    init(api: APIType = API(),
         favorites: FavoritesServiceType = FavoritesService()) {
        self.api = api
        self.favorites = favorites
    }
}
