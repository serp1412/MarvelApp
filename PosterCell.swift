import UIKit

class PosterCell: UICollectionViewCell {
    static let preferredHeight: CGFloat = 300
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowRadius = 1.5
        clipsToBounds = true
    }

    func configure(with hero: MarvelHero) {
        titleLabel.text = hero.name
        imageView.loadImage(at: hero.thumbnail.url(for: .fullsize))
        imageView.contentMode = .scaleAspectFill
    }
}

extension PosterCell: NibLoadable {}
