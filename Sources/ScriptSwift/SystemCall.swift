#if canImport(Darwin)
import Darwin
func exit(withError error: Error? = nil) {
    guard let error = error else {
        exit(0)
    }

    fputs(error.localizedDescription, stderr)
    exit(1)
}
#elseif canImport(Glibc)
import Glibc
func exit(withError error: Error? = nil) {
    guard let error = error else {
        exit(0)
    }

    fputs(error.localizedDescription, stderr)
    exit(1)
}
#endif
