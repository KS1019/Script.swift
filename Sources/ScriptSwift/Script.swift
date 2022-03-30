import Files
import ShellOut
import struct Foundation.Data

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

    public func stdin() -> Script<String> {
        return .init(success: CommandLine.arguments.joined(separator: " "))
    }

    public func stdin() -> Script<[String]> {
        return .init(success: CommandLine.arguments)
    }

    public func stdout() {
        switch input {
        case .success(let input):
            print(input)
        case .failure(let error):
            exit(withError: error)
        }
    }

    public func exec(_ command: [String]) -> Script<String> {
        do {
            return .init(success: try shellOut(to: command))
        } catch {
            return .init(failure: error)
        }
    }

    public func exec(_ command: String) -> Script<String> {
        do {
            return .init(success: try shellOut(to: command))
        } catch {
            return .init(failure: error)
        }
    }

    public func ifExists(_ filename: String) -> Script<T> {
        do {
            _ = try File(path: filename)
            return self
        } catch {
            return .init(failure: error)
        }
    }

    public func map<N>(_ transform: (T) -> N) -> Script<N> {
        switch input {
        case .success(let input):
            return .init(success: transform(input))
        case .failure(let error):
            return .init(failure: error)
        }
    }

    public func raw() -> T {
        switch input {
        case .success(let input):
            return input
        case .failure(let error):
            exit(withError: error)
        }
    }

    public func asString() -> String {
        switch input {
        case .success(let input):
            return String(describing: input)
        case .failure(let error):
            return String(describing: error)
        }
    }
}
