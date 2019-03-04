import UIKit

extension UIImage {
    convenience init?(mr_named name: String) {
        self.init(named: name, in: Bundle.framework, compatibleWith: nil)
    }
}
