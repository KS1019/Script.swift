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
            return XCTFail("Expected failure but got success")
        }

        XCTAssertEqual(result1.localizedDescription, """
                       ShellOut encountered an error
                       Status code: 127
                       Message: "/bin/bash: makes-no-sense: command not found"
                       Output: ""
                       """)

        guard case .failure(let result1) = Script().exec(command).input else {
            return XCTFail("Expected failure but got success")
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

    func testStdin() {
        CommandLine.arguments = ["Test", "Is", "Important"]

        XCTAssertEqual(Script().stdin().raw(), "Test Is Important")
        XCTAssertEqual(Script().stdin().raw(), ["Test", "Is", "Important"])
    }

    func testStdout() {
        let expectation = XCTestExpectation(description: "Test stdout")
        let listener = OutputListener()
        listener.openConsolePipe()
        let string = "hello"
        Script(success: string).stdout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(listener.contents, string + "\n")
            listener.closeConsolePipe()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

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

extension XCTest {
    class OutputListener {
        /// consumes the messages on STDOUT
        let inputPipe = Pipe()

        /// outputs messages back to STDOUT
        let outputPipe = Pipe()

        /// Buffers strings written to stdout
        var contents = ""

        init() {
            // Set up a read handler which fires when data is written to our inputPipe
            inputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
                guard let strongSelf = self else { return }

                let data = fileHandle.availableData
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    strongSelf.contents += string
                }

                // Write input back to stdout
                strongSelf.outputPipe.fileHandleForWriting.write(data)
            }
        }

        /// Sets up the "tee" of piped output, intercepting stdout then passing it through.
        func openConsolePipe() {
            // Copy STDOUT file descriptor to outputPipe for writing strings back to STDOUT
            dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)

            // Intercept STDOUT with inputPipe
            dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        }

        /// Tears down the "tee" of piped output.
        func closeConsolePipe() {
            // Restore stdout
            freopen("/dev/stdout", "a", stdout)

            [inputPipe.fileHandleForReading, outputPipe.fileHandleForWriting].forEach { file in
                file.closeFile()
            }
        }
    }
}
