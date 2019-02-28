import UIKit

extension UIView {
    func addToCenter(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
