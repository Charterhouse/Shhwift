import Quick
import Nimble
import Shhwift

class PayloadSpec: QuickSpec {
    override func spec() {

        let payloadData = "payload".dataUsingEncoding(NSUTF8StringEncoding)!

        it("can be constructed from data") {
            expect(Payload(payloadData)).toNot(beNil())
        }

        it("can be converted to data") {
            expect(Payload(payloadData).asData) == payloadData
        }

        it("implements the DataContainer protocol") {
            expect(Payload(payloadData) as DataContainer).toNot(beNil())
        }
    }
}
