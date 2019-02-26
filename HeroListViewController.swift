import UIKit

class HeroListViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "Main"

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var heroes: [MarvelHero] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Heroes"
        setupCollectionView()

        AppEnvironment.current.api.getHeroes { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.collectionView.reloadData()
            case .failure: break
            }
        }
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
        return heroes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier,
                                                      for: indexPath) as! HeroCell

        cell.configure(for: heroes[indexPath.row])

        return cell
    }
}
