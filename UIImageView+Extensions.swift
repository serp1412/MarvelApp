import UIKit

extension UIImageView {
    private static var requestIdKey = "UIImageViewRequestID"
    private var lastRequestedURL: String? {
        get {
            return objc_getAssociatedObject(self,
                                            &UIImageView.requestIdKey) as? String
        }

        set {
            objc_setAssociatedObject(self,
                                     &UIImageView.requestIdKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func loadImage(at url: URL) {
        lastRequestedURL = url.absoluteString
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                self?.lastRequestedURL == url.absoluteString else { return }
            DispatchQueue.main.sync {
                self?.image = UIImage(data: data)
            }
            }.resume()
    }
}
