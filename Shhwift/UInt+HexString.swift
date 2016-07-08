extension UInt {

    init?(hexString: String) {
        guard hexString.hasPrefix("0x") else {
            return nil
        }

        let hexStringWithoutPrefix = hexString
            .substringFromIndex(hexString.startIndex.advancedBy(2))

        self.init(hexStringWithoutPrefix, radix: 16)
    }

    var asHexString: String {
        return "0x" + String(self, radix:16, uppercase: false)
    }
}
