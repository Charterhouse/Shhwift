public struct Payload: DataContainer {

    private let data: NSData

    public init(_ data: NSData) {
        self.data = data
    }

    public var asData: NSData {
        return data
    }
}

extension Payload: Equatable {}
public func == (lhs: Payload, rhs: Payload) -> Bool {
    return lhs.data == rhs.data
}
