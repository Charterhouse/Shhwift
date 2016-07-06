import Quick
import Nimble
import Shhwift

class IdentitySpec: QuickSpec {
    override func spec() {

        let sixtyBytes = [UInt8](count: 60, repeatedValue: 42)
        let sixtyBytesData = NSData(bytes: sixtyBytes, length: sixtyBytes.count)

        it("can be constructed with 60 bytes data") {
            expect(Identity(sixtyBytesData)).toNot(beNil())
        }

        it("cannot be constructed with data of different length") {
            let invalidBytes = [UInt8](count: 50, repeatedValue: 42)
            let invalidData = NSData(bytes: invalidBytes, length: invalidBytes.count)
            expect(Identity(invalidData)).to(beNil())
        }

        it("can be converted to data") {
            expect(Identity(sixtyBytesData)?.asData) == sixtyBytesData
        }

        it("implements the DataContainer protocol") {
            expect(Identity(sixtyBytesData) as? DataContainer).toNot(beNil())
        }
    }
}
