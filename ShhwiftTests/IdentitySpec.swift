import Quick
import Nimble
import Shhwift

class IdentitySpec: QuickSpec {
    override func spec() {

        let sixtyFiveBytes = [UInt8](count: 65, repeatedValue: 42)
        let sixtyFiveBytesData = NSData(bytes: sixtyFiveBytes, length: sixtyFiveBytes.count)

        it("can be constructed with 65 bytes data") {
            expect(Identity(sixtyFiveBytesData)).toNot(beNil())
        }

        it("cannot be constructed with data of different length") {
            let invalidBytes = [UInt8](count: 50, repeatedValue: 42)
            let invalidData = NSData(bytes: invalidBytes, length: invalidBytes.count)
            expect(Identity(invalidData)).to(beNil())
        }

        it("can be converted to data") {
            expect(Identity(sixtyFiveBytesData)?.asData) == sixtyFiveBytesData
        }

        it("implements the DataContainer protocol") {
            expect(Identity(sixtyFiveBytesData) as? DataContainer).toNot(beNil())
        }
    }
}
