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
            switch result {
            case .success(let collection):
                self?.searchResults = collection.results
                self?.view.reloadData()
            case .failure: break
            }
        }
    }

    private func fetchFirstHeroes() {
        view.showLoading()
        AppEnvironment.current.api.getHeroes { [weak self] result in
            self?.view.hideLoading()
            switch result {
            case .success(let collection):
                self?.paginationGenerator = .init(pageSize: 20,
                                                  maxItemsCount: collection.total)
                self?.heroes = collection.results
                self?.view.reloadData()
            case .failure: break
            }
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
