import Quick
import Nimble
import Shhwift

class TopicSpec: QuickSpec {
    override func spec() {

        let thirtyTwoBytes = [UInt8](count: 32, repeatedValue: 42)
        let thirtyTwoBytesData = NSData(bytes: thirtyTwoBytes, length: thirtyTwoBytes.count)

        it("can be constructed with 32 bytes data") {
            expect(Topic(thirtyTwoBytesData)).toNot(beNil())
        }

        it("can be constructed with data of different length") {
            let bytes = [UInt8](count: 50, repeatedValue: 42)
            let data = NSData(bytes: bytes, length: bytes.count)
            expect(Topic(data)).toNot(beNil())
        }

        it("can be converted to data") {
            expect(Topic(thirtyTwoBytesData)?.asData) == thirtyTwoBytesData
        }

        it("implements the DataContainer protocol") {
            expect(Topic(thirtyTwoBytesData) as? DataContainer).toNot(beNil())
        }
    }
}
