import NSData_FastHex

public protocol DataContainer {
    init?(_ data: NSData)
    var asData: NSData { get }
}

extension DataContainer {

    public init?(_ bytes: [UInt8]) {
        self.init(NSData(bytes: bytes, length: bytes.count))
    }

    public init?(_ hexString: String) {
        guard hexString.hasPrefix("0x") else {
            return nil
        }

        let hexStringWithoutPrefix = hexString
            .substringFromIndex(hexString.startIndex.advancedBy(2))

        let parsedHexString = NSData(
            hexString: hexStringWithoutPrefix,
            ignoreOtherCharacters: false
        )

        guard let data = parsedHexString else {
            return nil
        }

        self.init(data)
    }

    public var asBytes: [UInt8] {
        let data = self.asData
        var result = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&result, length: data.length)
        return result
    }

    public var asHexString: String {
        return "0x" + self.asData.hexStringRepresentation()
    }
}
