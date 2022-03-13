import struct Foundation.Data
import Files

extension Script where T == File {
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
