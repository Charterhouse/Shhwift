import Quick
import Nimble

class UIntHexStringSpec: QuickSpec {
    override func spec() {

        it("converts to hexadecimal string with prefix") {
            expect(UInt(1024).asHexString) == "0x400"
        }

        it("can be constructed from a hex string") {
            expect(UInt(hexString: "0x400")) == 1024
        }

        it("cannot be constructed with an empty string") {
            let invalidString = ""
            expect(UInt(hexString: invalidString)).to(beNil())
        }

        it("cannot be constructed with string containing non-hex characters") {
            let invalidString = "0xZZ"
            expect(UInt(hexString: invalidString)).to(beNil())
        }

        it("cannot be constructed with a string that lacks the 0x prefix") {
            let invalidString = "--400"
            expect(UInt(hexString: invalidString)).to(beNil())
        }
    }
}
