import NSData_FastHex

public struct Identity {

    private let data: NSData

    public init?(_ data: NSData) {
        guard data.length == 60 else {
            return nil
        }

        self.data = data
    }

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

    public var asData: NSData {
        return data
    }

    public var asBytes: [UInt8] {
        var result = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&result, length: data.length)
        return result
    }

    public var asHexString: String {
        return "0x" + data.hexStringRepresentation()
    }
}
