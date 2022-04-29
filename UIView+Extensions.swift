import UIKit
import SnapKit

extension UIView {
    func addToCenter(_ subview: UIView) {
        addSubview(subview)
        subview.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    enum Side {
        case width(_ width: CGFloat)
        case height(_ height: CGFloat)
    }
    
    static func spacer(_ side: Side) -> UIView {
        let spacer = UIView()
        switch side {
        case .height(let height):
            spacer.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
        case .width(let width):
            spacer.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        }

        spacer.backgroundColor = .clear

        return spacer
    }
}
