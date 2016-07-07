public struct Identity: DataContainer {

    private let data: NSData

    public init?(_ data: NSData) {
        guard data.length == 60 else {
            return nil
        }

        self.data = data
    }

    public var asData: NSData {
        return data
    }
}

extension Identity: Equatable {}
public func == (lhs: Identity, rhs: Identity) -> Bool {
    return lhs.data == rhs.data
}
