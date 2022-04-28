import UIKit

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

public protocol NibLoadable: AnyObject, Identifiable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        let views = Bundle.main.loadNibNamed(nibName,
                                        owner: nil,
                                        options: nil) ?? []

        return views.lazy.compactMap { $0 as? UIView }.first! as! Self
    }
}

extension UICollectionView {
    func register<T: NibLoadable>(_ type: T.Type) {
        let nib = UINib(nibName: type.nibName, bundle: .main)
        register(nib, forCellWithReuseIdentifier: type.identifier)
    }

    func register<T: NibLoadable>(_ type: T.Type, forSupplementaryViewOfKind kind: String) {
        let nib = UINib(nibName: type.nibName, bundle: .main)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.identifier)
    }
}
