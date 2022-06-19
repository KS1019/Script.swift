import struct Files.File
import ShellOut

extension Script where T == String {
    public init() {
        self.init(success: "")
    }

    /// This function executes externtal command using the input `String` value.
    /// - Returns: ``Script`` object containing `String` value or failure
    public func exec() -> Script<String> {
        switch input {
        case .success(let input):
            let command = input.components(separatedBy: " ")
            do {
                return .init(success: try shellOut(to: command))
            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This function pass `self` to next function in the method chain if a file exists using the input `String` value.
    /// - Returns: ``Script`` object passed from previous function or failure
    public func ifExists() -> Script<String> {
        switch input {
        case .success(let input):
            do {
                _ = try File(path: input)
                return self
            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This function passes `String` value only when matched.
    /// - Parameter string: `String` value to match
    /// - Returns: ``Script`` object with only matched `String` value or failure
    public func match(_ string: String) -> Script<String> {
        switch input {
        case .success(let input):
            return
                .init(success: input
                    .components(separatedBy: "\n")
                    .filter { $0.contains(string) }
                    .joined(separator: "\n")
                )
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This function returns the number of lines of `String` input value.
    /// - Returns: ``Script`` object with `Int` value of the number of lines
    public func countLines() -> Script<Int> {
        switch input {
        case .success(let input):
            return .init(success: input.components(separatedBy: "\n").count)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This function combines files using input `String` value as file names, and outputs the combined files as  `Array` of `String`.
    /// - Returns:  ``Script`` object with `Array` of `String`
    public func concat() -> Script<[String]> {
        switch input {
        case .success(let input):
            return
                .init(success: input
                    .components(separatedBy: "\n")
                    .compactMap {
                        try? File(path: $0).readAsString()
                    }
                )
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This function passes multi-line `String` value as `Array` to next ``Script`` method.
    /// - Returns: ``Script`` object with `Array` of `String` value
    public func asArray() -> Script<[String]> {
        switch input {
        case .success(let input):
            return .init(success: input.components(separatedBy: "\n"))
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
