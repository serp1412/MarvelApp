import XCTest

extension XCTestCase {
    func asyncAssert(_ assert: @escaping () -> ()) {
        let exp = expectation(description: "genericexpect")
        let deadlineTime = DispatchTime.now() + .nanoseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            assert()
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
