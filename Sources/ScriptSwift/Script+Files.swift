import struct Foundation.Data
import Files

extension Script where T == File {
    /// This function reads file from the value of the previous ``Script`` method.
    /// - Returns: ``Script`` object with `Data` representation of the file or failure
    public func read() -> Script<Data> {
        switch input {
        case .success(let input):
            do {
                let data = try input.read()
                return .init(success: data)
            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }
    
    /// This function reads file from the value of the previous ``Script`` method.
    /// - Parameter encoded: This indicates how the file is encoded.
    /// - Returns: ``Script`` object with `String` representation of the file or failure
    public func read(encoded: String.Encoding = .utf8) -> Script<String> {
        switch input {
        case .success(let input):
            do {
                let string = try input.readAsString(encodedAs: encoded)
                return .init(success: string)
            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
