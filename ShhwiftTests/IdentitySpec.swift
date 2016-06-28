import Quick
import Nimble
import Shhwift
import NSData_FastHex

class IdentitySpec: QuickSpec {
    override func spec() {

        let sixtyBytes = [UInt8](count: 60, repeatedValue: 42)
        let sixtyBytesData = NSData(bytes: sixtyBytes, length: sixtyBytes.count)
        let sixtyBytesString = "0x" + sixtyBytesData.hexStringRepresentation()

        it("can be constructed with 60 bytes") {
            expect(Identity(sixtyBytes)).toNot(beNil())
        }

        it("can be constructed with 60 bytes data") {
            expect(Identity(sixtyBytesData)).toNot(beNil())
        }

        it("can be constructed with a 60 byte hex string") {
            expect(Identity(sixtyBytesString)).toNot(beNil())
        }

        it("cannot be constructed with a byte array of different length") {
            let invalidBytes = [UInt8](count: 50, repeatedValue: 42)
            expect(Identity(invalidBytes)).to(beNil())
        }

        it("cannot be constructed with data of different length") {
            let invalidBytes = [UInt8](count: 50, repeatedValue: 42)
            let invalidData = NSData(bytes: invalidBytes, length: invalidBytes.count)
            expect(Identity(invalidData)).to(beNil())
        }

        it("cannot be constructed with a hex string of different length") {
            let invalidString = sixtyBytesString + "AB"
            expect(Identity(invalidString)).to(beNil())
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
            let invalidString = "--" + sixtyBytesData.hexStringRepresentation()
            expect(Identity(invalidString)).to(beNil())
        }

        it("can be converted to a byte array") {
            expect(Identity(sixtyBytes)?.asBytes) == sixtyBytes
        }

        it("can be converted to data") {
            expect(Identity(sixtyBytesData)?.asData) == sixtyBytesData
        }

        it("can be converted to a hex string") {
            expect(Identity(sixtyBytes)?.asHexString) == sixtyBytesString
        }
    }
}
