import UIKit

class HeroListViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "Main"

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var heroes: [MarvelHero] = []
    var searchResults: [MarvelHero] = []
    var isInSearchMode = false
    var paginationGenerator = PageOffsetGenerator()
    var nextPageFetchingInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavigationItem()
        definesPresentationContext = true
        fetchFirstHeroes()
    }

    private func fetchFirstHeroes() {
        AppEnvironment.current.api.getHeroes { [weak self] result in
            switch result {
            case .success(let collection):
                self?.paginationGenerator = .init(pageSize: 20,
                                                  maxItemsCount: collection.total)
                self?.heroes = collection.results
                self?.collectionView.reloadData()
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
                self?.collectionView.reloadData()
            case .failure:
                self?.paginationGenerator.rewind()
            }

            self?.nextPageFetchingInProgress = false
        }
    }

    private func setupNavigationItem() {
        navigationItem.title = "Heroes"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.delegate = self
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeroCell.self)
    }

    private func shouldFetchNextPage(at indexPath: IndexPath) -> Bool {
        return indexPath.row + 1 >= heroes.count && !nextPageFetchingInProgress && !allPagesLoaded && !isInSearchMode
    }

    private var allPagesLoaded: Bool {
        return paginationGenerator.allPagesLoaded && !nextPageFetchingInProgress
    }
}

extension HeroListViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }

        isInSearchMode = true
        AppEnvironment.current.api.getHeroes(name: text) { [weak self] (result) in
            switch result {
            case .success(let collection):
                self?.searchResults = collection.results
                self?.collectionView.reloadData()
            case .failure: break
            }
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        isInSearchMode = false
        collectionView.reloadData()
    }
}

extension HeroListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
// TODO
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 272)
    }
}

extension HeroListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return isInSearchMode ? searchResults.count : heroes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier,
                                                      for: indexPath) as! HeroCell

        let array = isInSearchMode ? searchResults : heroes

        cell.configure(for: array[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard shouldFetchNextPage(at: indexPath) else { return }
        fetchNextHeroes()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return !heroes.isEmpty && !isInSearchMode && !allPagesLoaded ?
            CGSize(width: collectionView.frame.width, height: 60) :
            .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: "HeroListFooterView",
                                                               for: indexPath)
    }
}

