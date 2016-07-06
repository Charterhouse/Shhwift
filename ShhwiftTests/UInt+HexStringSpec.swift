import Quick
import Nimble

class UIntHexStringSpec: QuickSpec {
    override func spec() {

        it("converts to hexadecimal string with prefix") {
            expect(UInt(1024).asHexString) == "0x400"
        }
    }
}
