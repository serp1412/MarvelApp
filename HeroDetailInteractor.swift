import UIKit

protocol HeroDetailInput {
    func reloadData()
    func showLoading()
    func hideLoading()
}

enum DetailCellType {
    case poster
    case card
}

protocol HeroDetailOutput {
    func viewDidLoad()
    var numberOfSections: Int { get }
    var hero: MarvelHero { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func cellTypeForSection(_ section: Int) -> DetailCellType
    func product(at indexPath: IndexPath) -> HeroProduct
    func titleForSection(_ section: Int) -> String
}

class HeroDetailInteractor: HeroDetailOutput {
    struct Section {
        let title: String
        let products: [HeroProduct]
    }

    var view: HeroDetailInput!
    let hero: MarvelHero
    var numberOfSections: Int {
        return sections.count + 1
    }
    private var sections: [Section] = []
    private let dispatchGroup = DispatchGroup()

    init(hero: MarvelHero) {
        self.hero = hero
    }

    func viewDidLoad() {
        fetchData()
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        return section == 0 ? 1 : sections[section - 1].products.count
    }

    func cellTypeForSection(_ section: Int) -> DetailCellType {
        return section == 0 ? .poster : .card
    }

    func product(at indexPath: IndexPath) -> HeroProduct {
        return sections[indexPath.section - 1].products[indexPath.row]
    }

    func titleForSection(_ section: Int) -> String {
        return sections[section - 1].title
    }

    private func fetchData() {
        func addSection(kind: HeroProductsRequest.Kind, products: [HeroProduct]) {
            if products.isEmpty { return }
            let section = Section(title: kind.sectionTitle, products: products)
            self.sections.append(section)
        }

        view.showLoading()

        fetchData(ofKind: .comics, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .series, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .stories, withUpdate: addSection(kind:products:))
        fetchData(ofKind: .events, withUpdate: addSection(kind:products:))

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.view.reloadData()
            self?.view.hideLoading()
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
