import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    private var hero: MarvelHero?

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.5
        imageView.backgroundColor = UIColor.lightGray
        isUserInteractionEnabled = true
        bringSubviewToFront(favoriteButton)
        let image = UIImage(mr_named: "star")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)

    }

    func configure(for hero: MarvelHero) {
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
        imageView.loadImage(at: hero.thumbnail.url(for: .portrait))
        self.hero = hero
        configureFavorite()
    }

    func configure(for product: HeroProduct) {
        favoriteButton.isHidden = true
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        guard let thumbnail = product.thumbnail else { return }
        imageView.loadImage(at: thumbnail.url(for: .portrait))
    }

    fileprivate var toggle = false

    @IBAction func toggleFavorite() {
        hero.flatMap { AppEnvironment.current.favorites.toggleWithId($0.id) }
        configureFavorite()
    }

    private var isFavoriteHero: Bool {
        guard let hero = hero else { return false }
        return AppEnvironment.current.favorites.isFavoriteHeroWithId(hero.id)
    }

    private func configureFavorite() {
        favoriteButton.tintColor = isFavoriteHero ? .red : .gray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}

extension CardCell: NibLoadable {}
