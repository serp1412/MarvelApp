import UIKit

extension UIView {
    func addToCenter(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .width(let width):
            spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        spacer.backgroundColor = .clear

        return spacer
    }
}
