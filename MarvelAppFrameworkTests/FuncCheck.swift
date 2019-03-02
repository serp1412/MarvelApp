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

extension FuncCheck where T: Equatable {
    func wasCalled(with otherValue: T) -> Bool {
        return value == otherValue && wasCalled
    }
}

extension FuncCheck {
    func wasCalled<V1, V2>(with otherTuple: (V1?, V2?)?) -> Bool
        where V1: Equatable, V2: Equatable, T == (V1?, V2?) {
            return value == otherTuple && wasCalled
    }

    func wasCalled<V1, V2>(with otherTuple: (V1?, V2)?) -> Bool
        where V1: Equatable, V2: Equatable, T == (V1?, V2) {
            return (value?.0, value?.1) == (otherTuple?.0, otherTuple?.1) && wasCalled
    }

    func wasCalled<V1, V2>(with otherTuple: (V1, V2?)?) -> Bool
        where V1: Equatable, V2: Equatable, T == (V1, V2?) {
            return (value?.0, value?.1) == (otherTuple?.0, otherTuple?.1) && wasCalled
    }

    func wasCalled<V1, V2>(with otherTuple: (V1, V2)?) -> Bool
        where V1: Equatable, V2: Equatable, T == (V1, V2) {
            return (value?.0, value?.1) == (otherTuple?.0, otherTuple?.1) && wasCalled
    }
}

func == <V1, V2>(lhs: (V1?, V2?)?, rhs: (V1?, V2?)?) -> Bool where V1: Equatable, V2: Equatable {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return lValue.0 == rValue.0 && lValue.1 == rValue.1
    default:
        return false
    }
}
