import UIKit
import LazyTransitions
import SnapKit

class HeroDetailViewController: UIViewController, StoryboardInstantiable {
    enum Constants {
        static let storyboardName = "HeroDetail"
        static let iconSize: CGFloat = 24
        
        // collection view constants
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let sectionHeaderHeight: CGFloat = 50
    }
    
    static let storyboardName = Constants.storyboardName
    var interactor: HeroDetailOutput!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        becomeLazy(for: .pop)
        setupCollectionView()
        setupBarButtonItem()
        interactor.viewDidLoad()
    }

    private func setupBarButtonItem() {
        let image = Images.star.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.iconSize)
        }

        navigationItem.rightBarButtonItem = .init(customView: button)
    }

    private func setupCollectionView() {
        collectionView.register(CardCell.self)
        collectionView.register(PosterCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        collectionView.collectionViewLayout = layout
    }

    @objc private func favoriteButtonTapped() {
        interactor.favoriteButtonTapped()
    }
}

extension HeroDetailViewController: HeroDetailInput {
    func favorite() {
        navigationItem.rightBarButtonItem?.customView?.tintColor = .orange
    }

    func unfavorite() {
        navigationItem.rightBarButtonItem?.customView?.tintColor = .gray
    }

    func reloadData() {
        collectionView.reloadData()
    }

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

extension HeroDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return interactor.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return interactor.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch interactor.cellTypeForSection(indexPath.section) {
        case .poster: return posterCell(collectionView, cellForItemAt: indexPath)
        case .card: return cardCell(collectionView, cellForItemAt: indexPath)
        }
    }

    private func posterCell(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> PosterCell {
        let cell = collectionView.dequeue(PosterCell.self, for: indexPath)
        cell.configure(with: interactor.hero)

        return cell
    }

    private func cardCell(_ collectionView: UICollectionView,
                          cellForItemAt indexPath: IndexPath) -> CardCell {
        let cell = collectionView.dequeue(CardCell.self, for: indexPath)
        cell.configure(for: interactor.product(at: indexPath))

        return cell
    }
}

extension HeroDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section > 0 ?
            .init(width: collectionView.frame.width, height: Constants.sectionHeaderHeight):
            .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return indexPath.section == 0 ?
            .init(width: collectionView.frame.width, height: PosterCell.preferredHeight):
            .init(width: collectionView.frame.width, height: CardCell.preferredHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            indexPath.section != 0 else { return UICollectionReusableView() }

        let header = collectionView.dequeueSupplementaryView(HeroDetailSectionHeader.self,
                                                             for: indexPath,
                                                             kind: UICollectionView.elementKindSectionHeader)

        header.titleLabel.text = interactor.titleForSection(indexPath.section)

        return header
    }
}
