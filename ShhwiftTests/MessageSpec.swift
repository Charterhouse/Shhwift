import Quick
import Nimble
import SwiftyJSON
@testable import Shhwift

class MessageSpec: QuickSpec {
    override func spec() {

        let topics = [Topic.example, Topic.example]
        let payload = Payload.example

        it("can be created from a JSON dictionary") {

            let json = JSON([
                "topics": topics.map { $0.asHexString },
                "payload": payload.asHexString
            ])!

            let message = Message(fromJson: json)

            expect(message?.topics) == topics
            expect(message?.payload) == payload
        }

        it("cannot be created from a JSON dictionary without topics") {

            let invalidJson = JSON([
                "payload": payload.asHexString
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }

        it("cannot be created from a JSON dictionary with invalid topics") {

            let invalidJson = JSON([
                "topics": [ Topic.example.asHexString, "0xInvalidTopic" ],
                "payload": payload.asHexString
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }

        it("cannot be created from a JSON dictionary without payload") {

            let invalidJson = JSON([
                "topics": topics.map { $0.asHexString },
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }

        it("cannot be created from a JSON dictionary with invalid payload") {

            let invalidJson = JSON([
                "topics": topics.map { $0.asHexString },
                "payload": "0xInvalidPayload"
            ])!

            expect(Message(fromJson: invalidJson)).to(beNil())
        }
    }
}
