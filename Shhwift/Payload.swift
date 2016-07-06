public struct Payload: DataContainer {

    private let data: NSData

    public init(_ data: NSData) {
        self.data = data
    }

    public var asData: NSData {
        return data
    }
}
