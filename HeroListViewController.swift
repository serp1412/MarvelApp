import UIKit

class HeroListViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "Main"

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var heroes: [MarvelHero] = []
    var searchResults: [MarvelHero] = []
    var isInSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavigationItem()
        definesPresentationContext = true
        fetchHeroes()
    }

    private func fetchHeroes() {
        AppEnvironment.current.api.getHeroes { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.collectionView.reloadData()
            case .failure: break
            }
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
}

extension HeroListViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }

        isInSearchMode = true
        AppEnvironment.current.api.getHeroes(name: text) { [weak self] (result) in
            switch result {
            case .success(let heroes):
                self?.searchResults = heroes
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

        return CGSize.init(width: collectionView.frame.width, height: 272)
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
}
