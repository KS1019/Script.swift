import XCTest
@testable import Scripting
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
            return XCTFail("Expected failure but got success")
        }

        #if os(macOS)
        XCTAssertEqual(result1.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: makes-no-sense: command not found"
                       Output: ""
                       """)
        #else
        XCTAssertEqual(result1.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: line 1: makes-no-sense: command not found"
                       Output: ""
                       """)
        #endif

        guard case .failure(let result2) = Script().exec(command).input else {
            return XCTFail("Expected failure but got success")
        }

        #if os(macOS)
        XCTAssertEqual(result2.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: makes-no-sense: command not found"
                       Output: ""
                       """)
        #else
        XCTAssertEqual(result1.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: line 1: makes-no-sense: command not found"
                       Output: ""
                       """)
        #endif
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

    // func testStdin() {
    //     CommandLine.arguments = ["Test", "Is", "Important"]

    //     XCTAssertEqual(Script().stdin().raw(), "Test Is Important")
    //     XCTAssertEqual(Script().stdin().raw(), ["Test", "Is", "Important"])
    // }

    func testIfExists() {
        let md = Bundle.module.url(forResource: "TESTING", withExtension: "md")!
        XCTAssertEqual(Script(success: md.path).ifExists().map { URL(fileURLWithPath: $0).lastPathComponent }.raw(), "TESTING.md")
        XCTAssertEqual(Script(success: "Is it equal?").ifExists(md.path).raw(), "Is it equal?")

        guard case .failure(let error1) = Script(success: Bundle.main.bundlePath + "NotAFile.md").ifExists().input else {
            return XCTFail("Expected failure but got success")
        }

        XCTAssertNotNil(error1)

        guard case .failure(let error2) = Script().ifExists("NotAFile.md").input else {
            return XCTFail("Expected failure but got success")
        }

        XCTAssertNotNil(error2)
    }

    func testAsString() {
        XCTAssertEqual(Script(success: 10).asString(), "10")
        XCTAssertEqual(Script(success: "String").asString(), "String")
    }
}
