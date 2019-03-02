enum HeroDetailBuilder {
    static func build(with hero: MarvelHero) -> HeroDetailViewController {
        let view = HeroDetailViewController.instantiate()
        let interactor = HeroDetailInteractor(hero: hero)

        view.interactor = interactor
        interactor.view = view

        return view
    }
}
