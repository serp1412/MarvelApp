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
        imageView.backgroundColor = UIColor.lightGray
    }

    func configure(for hero: MarvelHero) {
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
        imageView.loadImage(at: hero.thumbnail.url(for: .portrait))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}

extension HeroCell: NibLoadable {}
