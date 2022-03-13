/// Scripting methods whose values are comparable
extension Script where T: Comparable {
    /// Return Bool value by comparing the piped value and the parameter `number`.
    ///
    /// This method return true when the piped value is more than `number` and false otherwise.
    public func more(than number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input > number)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// Return Bool value by comparing the piped value and the parameter `number`.
    ///
    /// This method return true when the piped value is less than `number` and false otherwise.
    public func less(than number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input < number)
        case .failure(let error):
            return .init(failure: error)
        }
    }

    /// Return Bool value by comparing the piped value and the parameter `number`.
    ///
    /// This method return true when the piped value is equal to `number` and false otherwise.
    public func equal(to number: T) -> Script<Bool> {
        switch input {
        case .success(let input):
            return .init(success: input == number)
        case .failure(let error):
            return .init(failure: error)
        }
    }
}
