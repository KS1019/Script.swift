/// Scripting methods whose values are comparable
extension Script where T: Comparable {

    /// This method return true when the piped value is more than `number` and false otherwise.
    /// - Parameter number: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `number`
    public func more(than number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input > number)
        case .failure(let error):
            return .init(failure: error)
        }
    }


    /// This method return true when the piped value is less than `number` and false otherwise.
    /// - Parameter number: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `number`
    public func less(than number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input < number)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// This method return true when the piped value is equal to `number` and false otherwise.
    /// - Parameter number: `Comparable` value
    /// - Returns: Bool value by comparing the piped value and the parameter `number`
    public func equal(to number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input == number)
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
