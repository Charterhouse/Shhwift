import Quick
import Nimble
import SwiftyJSON
@testable import Shhwift

class MessageSpec: QuickSpec {
    override func spec() {

        let payload = Payload.example

        it("can be created from a JSON dictionary") {

            let json = JSON([
                "payload": payload.asHexString
            ])!

            let message = Message(fromJson: json)

            expect(message?.payload) == payload
        }

        it("cannot be created from a JSON dictionary without payload") {

            let invalidJson = JSON([
                "foo": "bar"
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }

        it("cannot be created from a JSON dictionary with invalid payload") {

            let invalidJson = JSON([
                "payload": "0xInvalidPayload"
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }
    }
}
