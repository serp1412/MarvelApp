import Foundation

class FuncCheck<T> {
    private let queue = DispatchQueue(label: "marvel_app_queue")
    private var callTime: Date?
    private var onCallAction: ((T) -> Void)?

    private(set) var wasCalled = false
    private(set) var callCount = 0
    private(set) var value: T?
    private(set) var values: [T] = []
    var wasNotCalled: Bool {
        return queue.sync {
            !wasCalled
        }
    }

    func call(_ parameter: T) {
        queue.sync {
            value = parameter
            values.append(parameter)
            callCount += 1
            wasCalled = true
            callTime = Date()
            onCallAction?(parameter)
        }
    }

    func onCall(_ action: @escaping (T) -> Void) {
        queue.sync {
            onCallAction = action
        }
    }

    func wasCalled<U>(before funcCheck: FuncCheck<U>) -> Bool {
        switch (callTime, funcCheck.callTime) {
        case let (.some(leftDate), .some(rightDate)):
            return leftDate < rightDate
        default:
            return false
        }
    }

    func wasCalled<U>(after funcCheck: FuncCheck<U>) -> Bool {
        return !wasCalled(before: funcCheck)
    }

    func reset() {
        queue.sync {
            value = nil
            values = []
            callCount = 0
            wasCalled = false
            callTime = nil
            onCallAction = nil
        }
    }
}

class ZeroArgumentsFuncCheck: FuncCheck<Void> {
    func call() {
        super.call(())
    }
}

class StubbableFuncCheck<T, Stub>: FuncCheck<T> {
    var stub: Stub

    init(stub: Stub) {
        self.stub = stub
    }
}

class ClosureStubFuncCheck<T, Stub>: FuncCheck<T> {
    let filter: (T) -> ClosureStub<Stub>

    init(filter: @escaping (T) -> ClosureStub<Stub> = { _ in .doNotCall }) {
        self.filter = filter
    }

    func call(with parameter: T) -> ClosureStub<Stub> {
        super.call(parameter)

        return filter(parameter)
    }
}

extension FuncCheck where T: Equatable {
    func wasCalled(with otherValue: T) -> Bool {
        return value == otherValue && wasCalled
    }
}

extension FuncCheck {
    func wasCalled<V1, V2>(with otherTuple: (V1?, V2)?) -> Bool
        where V1: Equatable, V2: Equatable, T == (V1?, V2) {
            return value == otherTuple && wasCalled
    }

    func wasCalled<V1, V2, V3>(with otherTuple: (V1, V2, V3)) -> Bool
        where V1: Equatable, V2: Equatable, V3: Equatable, T == (V1, V2, V3) {
            return value == otherTuple && wasCalled
    }

    func wasEverCalled<V1, V2, V3>(with otherTuple: (V1, V2, V3)) -> Bool
        where V1: Equatable, V2: Equatable, V3: Equatable, T == (V1, V2, V3) {
            return values.contains(where: { $0 == otherTuple })
    }
}

func == <V1, V2>(lhs: (V1?, V2)?, rhs: (V1?, V2)?) -> Bool where V1: Equatable, V2: Equatable {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return lValue.0 == rValue.0 && lValue.1 == rValue.1
    default:
        return false
    }
}

func == <V1, V2, V3>(lhs: (V1, V2, V3)?, rhs: (V1, V2, V3)) -> Bool where V1: Equatable, V2: Equatable, V3: Equatable {
    guard let lhs = lhs else { return false }
    return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
}
