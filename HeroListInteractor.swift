protocol HeroListInput {
    func reloadData()
    func showLoading()
    func hideLoading()
}

protocol HeroListOutput {
    var shouldShowFooter: Bool { get }
    var numberOfHeroes: Int { get }
    func viewDidLoad()
    func willDisplayCellAtIndex(_ index: Int)
    func heroForIndex(_ index: Int) -> MarvelHero
    func searchBarDidEndEditingWithText(_ text: String?)
    func willDismissSearch()
}

class HeroListInteractor: HeroListOutput {
    var view: HeroListInput!
    fileprivate var heroes: [MarvelHero] = []
    private var searchResults: [MarvelHero] = []
    private var isInSearchMode = false
    private var paginationGenerator = PageOffsetGenerator()
    private var nextPageFetchingInProgress = false
    private var allPagesLoaded: Bool { return paginationGenerator.allPagesLoaded && !nextPageFetchingInProgress }
    var shouldShowFooter: Bool { return !heroes.isEmpty && !isInSearchMode && !allPagesLoaded }
    var numberOfHeroes: Int { return isInSearchMode ? searchResults.count : heroes.count }

    func viewDidLoad() {
        fetchFirstHeroes()
    }

    func willDisplayCellAtIndex(_ index: Int) {
        guard shouldFetchNextPage(at: index) else { return }
        fetchNextHeroes()
    }

    func heroForIndex(_ index: Int) -> MarvelHero {
        let array = isInSearchMode ? searchResults : heroes

        return array[index]
    }

    func willDismissSearch() {
        isInSearchMode = false
        view.reloadData()
    }

    func searchBarDidEndEditingWithText(_ text: String?) {
        guard let text = text, !text.isEmpty else { return }

        isInSearchMode = true
        AppEnvironment.current.api.getHeroes(name: text) { [weak self] (result) in
            guard let results = result.value?.results else { return }
            self?.searchResults = results
            self?.view.reloadData()
        }
    }

    private func fetchFirstHeroes() {
        view.showLoading()
        AppEnvironment.current.api.getHeroes { [weak self] result in
            self?.view.hideLoading()
            guard let collection = result.value else { return }

            self?.paginationGenerator = .init(pageSize: collection.limit,
                                              maxItemsCount: collection.total,
                                              currentOffset: collection.limit)
            self?.heroes = collection.results
            self?.view.reloadData()
        }
    }

    private func fetchNextHeroes() {
        nextPageFetchingInProgress = true
        AppEnvironment.current.api.getHeroes(offset: paginationGenerator.next()) { [weak self] result in
            switch result {
            case .success(let collection):
                self?.heroes += collection.results
                self?.view.reloadData()
            case .failure:
                self?.paginationGenerator.rewind()
            }

            self?.nextPageFetchingInProgress = false
        }
    }

    private func shouldFetchNextPage(at index: Int) -> Bool {
        return index + 1 >= heroes.count && !nextPageFetchingInProgress && !allPagesLoaded && !isInSearchMode
    }
}
