#if canImport(Darwin)
import Darwin
let _exit = Darwin.exit
#elseif canImport(Glibc)
import Glibc
let _exit = Glibc.exit
#endif

/// This function exit current process with error if given.
/// - Parameter error: `Error` object
/// - Returns: `Never`
func exit(withError error: Error? = nil) -> Never {
    guard let error = error else {
        _exit(0)
    }

    fputs(error.localizedDescription, stderr)
    _exit(1)
}
