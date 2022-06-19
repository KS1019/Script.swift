import Files
import ShellOut
import struct Foundation.Data

/// Script type
///
/// By using method chain, you can express a workflow of your script in Swift.
public struct Script<T> {
    var input: Result<T, Error>

    internal init(input: Result<T, Error>) {
        self.input = input
    }

    public init(success: T) {
        self.init(input: .success(success))
    }

    internal init(failure: Error) {
        self.init(input: .failure(failure))
    }
    
    /// This function collects inputs from stdin and returns as String.
    /// - Returns: Script object containing String value or failure
    public func stdin() -> Script<String> {
        guard let array: [String] = readLine()?.split(separator: " ").map({ s in String(s) }) else { return .init(success: "") }
        return .init(success: array.joined(separator: " "))
    }
    
    /// This function accepts inputs and outputs it to stdout.
    public func stdout() {
        switch input {
        case .success(let input):
            print(input)
        case .failure(let error):
            exit(withError: error)
        }
    }
    
    /// This function executes externtal command.
    /// - Parameter command: Array of String to execute command
    /// - Returns: Script object containing String value or failure
    public func exec(_ command: [String]) -> Script<String> {
        do {
            return .init(success: try shellOut(to: command))
        } catch {
            return .init(failure: error)
        }
    }
    
    /// This function executes externtal command.
    /// - Parameter command: String to execute command
    /// - Returns: Script object containing String value or failure
    public func exec(_ command: String) -> Script<String> {
        do {
            return .init(success: try shellOut(to: command))
        } catch {
            return .init(failure: error)
        }
    }
    
    /// This function pass `self` to next function in the method chain if a file exists.
    /// - Parameter filename: String to represent name of a file
    /// - Returns: Script object passed from previous function or failure
    public func ifExists(_ filename: String) -> Script<T> {
        do {
            _ = try File(path: filename)
            return self
        } catch {
            return .init(failure: error)
        }
    }
    
    /// This function lets user modify the contained value in the method chain.
    /// - Parameter transform: A closure to modify the contained value
    /// - Returns: Script object with modified value or failure
    public func map<N>(_ transform: (T) -> N) -> Script<N> {
        switch input {
        case .success(let input):
            return .init(success: transform(input))
        case .failure(let error):
            return .init(failure: error)
        }
    }
    
    /// This function returns the contained value, ending the method chain.
    /// - Returns: The contained value or exit with failure
    public func raw() -> T {
        switch input {
        case .success(let input):
            return input
        case .failure(let error):
            exit(withError: error)
        }
    }
    
    /// This function returns the contained value or error as String.
    /// - Returns: String representaion of the contained value or error
    public func asString() -> String {
        switch input {
        case .success(let input):
            return String(describing: input)
        case .failure(let error):
            return String(describing: error)
        }
    }
}
