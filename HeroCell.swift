import UIKit

class HeroCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 1)
        imageView.layer.shadowOpacity = 0.5
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }

    func configure(for hero: MarvelHero) {
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
        guard let data = try? Data(contentsOf: hero.thumbnail.url(for: .portrait)) else { return }
        imageView.image = UIImage(data: data)
    }
}

extension HeroCell: NibLoadable {}
