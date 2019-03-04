enum Result<T> {
    case success(T)
    case failure
}

extension Result {
    var value: T? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
}
