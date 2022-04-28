import Foundation
import UIKit

extension UIViewControllerTransitionCoordinator {
    @discardableResult public func animate(
        _ animation: @autoclosure @escaping () -> Void,
        completion: @autoclosure @escaping () -> Void = { }()
    ) -> Bool {
        animate { _ in
            animation()
        } completion: { _ in
            completion()
        }
    }
}
