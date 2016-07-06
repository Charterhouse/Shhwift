import Quick
import Nimble
import Shhwift
import NSData_FastHex

class DataContainerSpec: QuickSpec {
    override func spec() {

        let bytes = [UInt8](count: 60, repeatedValue: 42)
        let data = NSData(bytes: bytes, length: bytes.count)
        let hexString = "0x" + data.hexStringRepresentation()

        it("can be constructed from bytes") {
            expect(Identity(bytes)).toNot(beNil())
        }

        it("can be constructed from data") {
            expect(Identity(data)).toNot(beNil())
        }

        it("can be constructed from a hex string") {
            expect(Identity(hexString)).toNot(beNil())
        }

        it("cannot be constructed with an empty string") {
            let invalidString = ""
            expect(Identity(invalidString)).to(beNil())
        }

        it("cannot be constructed with string containing non-hex characters") {
            let invalidString = "0x" + String(count: 60, repeatedValue:Character("Z"))
            expect(Identity(invalidString)).to(beNil())
        }

        it("cannot be constructed with a string that lacks the 0x prefix") {
            let invalidString = "--" + data.hexStringRepresentation()
            expect(Identity(invalidString)).to(beNil())
        }

        it("can be converted to a byte array") {
            expect(Identity(bytes)?.asBytes) == bytes
        }

        it("can be converted to data") {
            expect(Identity(data)?.asData) == data
        }

        it("can be converted to a hex string") {
            expect(Identity(bytes)?.asHexString) == hexString
        }
    }
}
