/// Scripting methods whose values are comparable
extension Script where T: Comparable {

    /// This method return true when the piped value is more than `rhs` and false otherwise.
    /// - Parameter rhs: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `rhs`
    public func more(than rhs: T) -> Script<Bool> {
        switch input {
        case .success(let lhs):
            return .init(success: lhs > rhs)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This method return true when the piped value is less than `rhs` and false otherwise.
    /// - Parameter rhs: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `rhs`
    public func less(than rhs: T) -> Script<Bool> {
        switch input {
        case .success(let lhs):
            return .init(success: lhs < rhs)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This method return true when the piped value is equal to `rhs` and false otherwise.
    /// - Parameter rhs: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `rhs`
    public func equal(to rhs: T) -> Script<Bool> {
        switch input {
        case .success(let lhs):
            return .init(success: lhs == rhs)
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
