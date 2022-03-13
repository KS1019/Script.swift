import XCTest
@testable import ScriptSwift
import ShellOut

final class ScriptUnitTests: XCTestCase {
    func testExec() throws {
        let command = #"echo "test""#
        let result1 = try Script().exec([command]).input.get()
        let result2 = try Script().exec(command).input.get()
        XCTAssertEqual(result1, "test")
        XCTAssertEqual(result2, "test")
    }
    
    func testExecInvalid() {
        let command = #"makes-no-sense"#
        guard case .failure(let result1) = Script().exec([command]).input else {
            return XCTFail("Expected failure")
        }
        
        XCTAssertEqual(result1.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: makes-no-sense: command not found"
                       Output: ""
                       """)
    }
    
    func testMap() {
        let command = #"echo "test""#
        XCTAssertEqual(Script().exec(command).map { "Hello from " + $0 }.raw(), "Hello from test")
    }
    
    func testMoreThan() {
        XCTAssertTrue(Script(success: 10).more(than: 9).raw())
        XCTAssertTrue(Script(success: -1).more(than: -2).raw())
        XCTAssertFalse(Script(success: 1).more(than: 10).raw())
        XCTAssertFalse(Script(success: -21).more(than: -1).raw())
    }
    
    func testLessThan() {
        XCTAssertTrue(Script(success: 1).less(than: 10).raw())
        XCTAssertTrue(Script(success: -21).less(than: -1).raw())
        XCTAssertFalse(Script(success: 10).less(than: 9).raw())
        XCTAssertFalse(Script(success: -1).less(than: -2).raw())
    }
    
    func testEqualTo() {
        XCTAssertTrue(Script(success: 1).equal(to: 1).raw())
        XCTAssertTrue(Script(success: -21).equal(to: -21).raw())
        XCTAssertFalse(Script(success: 10).equal(to: 9).raw())
        XCTAssertFalse(Script(success: -1).equal(to: -2).raw())
    }
}
