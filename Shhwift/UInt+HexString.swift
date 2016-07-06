extension UInt {
    var asHexString: String {
        return "0x" + String(self, radix:16, uppercase: false)
    }
}
