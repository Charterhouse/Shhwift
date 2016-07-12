public struct Topic: DataContainer {

    private let data: NSData

    public init?(_ data: NSData) {
        self.data = data
    }

    public var asData: NSData {
        return data
    }
}

extension Topic: Equatable {}
public func == (lhs: Topic, rhs: Topic) -> Bool {
    return lhs.data == rhs.data
}
