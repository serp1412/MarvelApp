import Foundation

extension Bundle {
    /// Returns a Bundle pinned to the framework target. We could choose anything for the `forClass`
    /// parameter as long as it is in the framework target.
    @objc(frameworkBundle)
    public static var framework: Bundle {
        return Bundle(for: CardCell.self)
    }
}
