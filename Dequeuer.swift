import UIKit

protocol Dequeuer {
    func dequeue<R: Identifiable>(_ type: R.Type, for indexPath: IndexPath) -> R
    func dequeueSupplementaryView<R: Identifiable>(_ type: R.Type, for indexPath: IndexPath, kind: String) -> R
}

extension Dequeuer {
    func dequeue<R>(for indexPath: IndexPath) -> R where R: Identifiable {
        return dequeue(R.self, for: indexPath)
    }

    func dequeueSupplementaryView<R>(for indexPath: IndexPath, kind: String) -> R where R: Identifiable {
        return dequeueSupplementaryView(R.self, for: indexPath, kind: kind)
    }
}

extension UICollectionView: Dequeuer {
    func dequeue<R: Identifiable>(_ type: R.Type, for indexPath: IndexPath) -> R {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as! R
    }

    func dequeueSupplementaryView<R: Identifiable>(_ type: R.Type, for indexPath: IndexPath, kind: String) -> R {
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: type.identifier,
                                                for: indexPath) as! R
    }
}
