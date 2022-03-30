import struct Foundation.Data
import Files

extension Script where T == Data {
    public func write(path: String) -> Script<File> {
        switch input {
        case .success(let input):
            do {
                let file = try Folder.current.file(at: path)
                try file.write(input)
                return .init(success: file)

            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }

    public func write(to filename: String) -> Script<File> {
        switch input {
        case .success(let input):
            do {
                let file = try Folder.current.file(named: filename)
                try file.write(input)
                return .init(success: file)

            } catch {
                return .init(failure: error)
            }
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
