import SnapshotTesting

let almostIdenticalPrecision: Float = 0.997

extension Snapshotting where Value == UIViewController, Format == UIImage {
    static var windowedImage: Snapshotting {
        return Snapshotting<UIImage, UIImage>.image(precision: almostIdenticalPrecision, scale: nil)
            .asyncPullback { vc in
                Async<UIImage> { callback in
                    UIView.setAnimationsEnabled(false)
                    let window = UIApplication.shared.windows[0]
                    window.rootViewController = vc
                    DispatchQueue.main.async {
                        let image = UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
                            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                        }
                        callback(image)
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
    }
}

// Adding this to fix the weird bug of slightly different snaps for
// Apple Silicon vs Intel based macs.
// A proper fix might be provided here at some point:
// https://github.com/pointfreeco/swift-snapshot-testing/issues/424
extension Snapshotting where Value == UIViewController, Format == UIImage {
    public static var almostIdenticalImage: Snapshotting {
        return .image(precision: almostIdenticalPrecision)
    }

    public static func almostIdenticalImage(
        on config: ViewImageConfig,
        precision: Float? = nil,
        size: CGSize? = nil,
        traits: UITraitCollection = .init()
    ) -> Snapshotting {
        return .image(on: config,
                      precision: precision ?? almostIdenticalPrecision,
                      size: size,
                      traits: traits)
    }
}
