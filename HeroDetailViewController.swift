import UIKit

class HeroDetailViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "HeroDetail"
    @IBOutlet private weak var collectionView: UICollectionView!

    private var hero: MarvelHero!
    private let dispatchGroup = DispatchGroup()
    private var sections: [Section] = []

    struct Section {
        let title: String
        let products: [HeroProduct]
    }

    static func instantiate(with hero: MarvelHero) -> HeroDetailViewController {
        let vc = instantiate()
        vc.hero = hero

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        setupCollectionView()
        fetchData()
    }

    private func setupCollectionView() {
        collectionView.register(CardCell.self)
        collectionView.register(PosterCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
    }

    private func fetchData() {
        func addSection(kind: HeroProductsRequest.Kind, products: [HeroProduct]) {
            if products.isEmpty { return }
            let section = Section(title: kind.sectionTitle, products: products)
            self.sections.append(section)
        }

        fetchData(ofKind: .comics, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .series, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .stories, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .events, withUpdate: addSection(kind:products:))

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func fetchData(ofKind kind: HeroProductsRequest.Kind, withUpdate f: @escaping (HeroProductsRequest.Kind, [HeroProduct]) -> Void) {
        dispatchGroup.enter()
        AppEnvironment.current.api.getHeroProducts(kind: kind, heroId: hero.id, limit: 3) { [weak self] result in
            f(kind, result.value?.results ?? [])
            self?.dispatchGroup.leave()
        }
    }
}

extension HeroDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return section == 0 ? 1 : sections[section - 1].products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return indexPath.section == 0 ?
            posterCell(collectionView, cellForItemAt: indexPath) :
            cardCell(collectionView, cellForItemAt: indexPath)
    }

    private func posterCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> PosterCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier,
                                                      for: indexPath) as! PosterCell

        cell.configure(with: hero)

        return cell
    }

    private func cardCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CardCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier,
                                                      for: indexPath) as! CardCell

        let product = sections[indexPath.section - 1].products[indexPath.row]
        cell.configure(for: product)

        return cell
    }
}

extension HeroDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section > 0 ?
            .init(width: collectionView.frame.width, height: 50) :
            .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return indexPath.section == 0 ?
            .init(width: collectionView.frame.width, height: 300) :
            .init(width: collectionView.frame.width, height: 272)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            indexPath.section != 0 else { return UICollectionReusableView() }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeroDetailSectionHeader.identifier, for: indexPath) as! HeroDetailSectionHeader

        header.titleLabel.text = sections[indexPath.section - 1].title

        return header
    }
}

extension HeroProductsRequest.Kind {
    fileprivate var sectionTitle: String {
        switch self {
        case .comics: return "Comics"
        case .series: return "Series"
        case .stories: return "Stories"
        case .events: return "Events"
        }
    }
}
