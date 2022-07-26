import ShellOut

extension Script {
    public func cd(to path: String) -> Script {
        do {
            try shellOut(to: "cd " + path)
            return self
        } catch {
            return .init(failure: error)
        }
    }
}
