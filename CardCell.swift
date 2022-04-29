import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    private var hero: MarvelHero?
    private var onInfoButtonTap: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.5
        imageView.backgroundColor = UIColor.lightGray
        isUserInteractionEnabled = true
        bringSubviewToFront(favoriteButton)
    }

    func configure(for hero: MarvelHero, infoButtonTapped: @escaping () -> Void) {
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
        imageView.loadImage(at: hero.thumbnail.url(for: .portrait))
        self.hero = hero
        self.onInfoButtonTap = infoButtonTapped
    }

    func configure(for product: HeroProduct) {
        favoriteButton.isHidden = true
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        guard let thumbnail = product.thumbnail else { return }
        imageView.loadImage(at: thumbnail.url(for: .portrait))
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    @IBAction private func infoButtonTapped() {
        onInfoButtonTap()
    }

    private var isFavoriteHero: Bool {
        guard let hero = hero else { return false }
        return AppEnvironment.current.favorites.isFavorite(hero.id)
    }
}

extension CardCell: NibLoadable {}
