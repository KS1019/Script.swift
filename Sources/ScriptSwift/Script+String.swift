import struct Files.File
import ShellOut

extension Script where T == String {
    public init() {
        self.init(success: "")
    }

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

    public func ifExists() -> Script<String> {
        switch input {
        case .success(let input):
            do {
                _ = try File(path: input)
                return .init(input: self.input)
            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }

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

    public func countLines() -> Script<Int> {
        switch input {
        case .success(let input):
            return .init(success: input.components(separatedBy: "\n").count)
        case .failure(let error):
            return .init(failure: error)
        }
    }

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

    public func asArray() -> Script<[String]> {
        switch input {
        case .success(let input):
            return .init(success: input.components(separatedBy: "\n"))
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
