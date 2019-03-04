import UIKit

class HeroListViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "HeroList"
    @IBOutlet private weak var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView?

    var interactor: HeroListOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavigationItem()
        definesPresentationContext = true
        interactor.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interactor.viewDidAppear()
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
        collectionView.register(CardCell.self)
    }
}

extension HeroListViewController: HeroListInput {
    func reloadData() { collectionView.reloadData() }

    func showLoading() {
        guard loadingIndicator == nil else { return }
        let indicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator = indicator
        collectionView.addToCenter(indicator)
        indicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
}

extension HeroListViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        interactor.searchBarDidEndEditingWithText(searchBar.text)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        interactor.willDismissSearch()
    }
}

extension HeroListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = interactor.heroForIndex(indexPath.row)
        let heroDetail = HeroDetailBuilder.build(with: hero)

        navigationController?.pushViewController(heroDetail, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 272)
    }
}

extension HeroListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return interactor.numberOfHeroes
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier,
                                                      for: indexPath) as! CardCell

        cell.configure(for: interactor.heroForIndex(indexPath.row))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor.willDisplayCellAtIndex(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return interactor.shouldShowFooter ?
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

