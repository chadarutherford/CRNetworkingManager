import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CRNetworkingManagerTests.allTests),
    ]
}
#endif
