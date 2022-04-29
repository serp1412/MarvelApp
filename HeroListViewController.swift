import UIKit

class HeroListViewController: UIViewController, StoryboardInstantiable {
    enum Constants {
        static let navigationTitle = "Heroes"
        static let storyboardName = "HeroList"
        
        // collection view constants
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let footerHeight: CGFloat = 60
        static let footerIdentifier = "HeroListFooterView"
    }
    static let storyboardName = Constants.storyboardName
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
        navigationItem.title = Constants.navigationTitle
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.delegate = self
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
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
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let hero = interactor.heroForIndex(indexPath.row)
        let heroDetail = HeroDetailBuilder.build(with: hero)

        navigationController?.pushViewController(heroDetail, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: CardCell.preferredHeight)
    }
}

extension HeroListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return interactor.numberOfHeroes
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CardCell.self, for: indexPath)

        let hero = interactor.heroForIndex(indexPath.row)
        cell.configure(for: hero) {
            let isFavorite = AppEnvironment.current.favorites.isFavorite(hero.id)
            let firstActionTitle = (isFavorite ? "Remove from" : "Add to") + " Favorites"

            let infoIcon = UIButton(type: .infoLight)
            infoIcon.tintColor = .gray
            infoIcon.isUserInteractionEnabled = false

            let actionSheet = ActionSheet.init(configuration: .init(header: .title(hero.name),
                                                                    maxHeight: 500))
            actionSheet.setActions([
                DefaultActionView(title: firstActionTitle,
                                  icon: .icon(Images.star,
                                              size: ActionSheetConstants.iconSize,
                                              color: isFavorite ? .orange : .gray),
                                  sheetToDismiss: actionSheet,
                                  onTap: {
                                      AppEnvironment.current.favorites.toggle(with: hero.id)
                                  }),
                DefaultActionView(title: "See Details",
                                  icon: .view(infoIcon),
                                  sheetToDismiss: actionSheet,
                                  onTap: { [weak self] in
                                      guard let self = self else { return }
                                      let heroDetail = HeroDetailBuilder.build(with: hero)

                                      self.navigationController?.pushViewController(heroDetail, animated: true)
                                  }),
            ])

            actionSheet.present(in: self)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        interactor.willDisplayCellAtIndex(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return interactor.shouldShowFooter ?
        CGSize(width: collectionView.frame.width, height: Constants.footerHeight):
            .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: Constants.footerIdentifier,
                                                               for: indexPath)
    }
}

