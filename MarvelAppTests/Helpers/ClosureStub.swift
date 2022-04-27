enum ClosureStub<T> {
    case call(T)
    case doNotCall

    func call(_ f: (T) -> Void) {
        switch self {
        case .call(let value): f(value)
        case .doNotCall: break
        }
    }
}
