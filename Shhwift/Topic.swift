public struct Topic: DataContainer {

    private let data: NSData

    public init?(_ data: NSData) {
        guard data.length == 32 else {
            return nil
        }

        self.data = data
    }

    public var asData: NSData {
        return data
    }
}
