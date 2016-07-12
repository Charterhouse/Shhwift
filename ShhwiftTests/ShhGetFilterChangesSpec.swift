import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhGetFilterChangesSpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
        }

        describe("get filter changes") {

            let someFilter = Filter.example

            it("calls the shh_getFilterChanges JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]) == "shh_getFilterChanges"
                        done()
                    }

                    shh.getFilterChanges(someFilter) { _, _ in return }
                }
            }

            it("adds the filter") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        let filterId = someFilter.id.asHexString
                        expect(json?["params"]) == JSON([filterId])
                        done()
                    }

                    shh.getFilterChanges(someFilter) { _, _ in return }
                }
            }

            it("returns the correct result") {

                let topics = [Topic.example, Topic.example]
                let payload = Payload.example

                self.stubRequests(
                    to: url,
                    result: json(["result": [
                        [
                            "topics": topics.map { $0.asHexString },
                            "payload": payload.asHexString
                        ]
                    ]])
                )

                waitUntil { done in
                    shh.getFilterChanges(someFilter) { messages, _ in
                        expect(messages?.count) == 1
                        expect(messages?[0].payload) == payload
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                self.stubRequests(to: url, result: http(404))

                waitUntil { done in
                    shh.getFilterChanges(someFilter) { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies when result is not a list of messages") {
                self.stubRequests(
                    to: url,
                    result: json(["result": "not a message list"])
                )

                waitUntil { done in
                    shh.getFilterChanges(someFilter) { _, error in
                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not a valid list of messages"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }

            it("notifies when a message is not valid") {
                self.stubRequests(
                    to: url,
                    result: json(["result": [["invalid": "message"]]])
                )

                waitUntil { done in
                    shh.getFilterChanges(someFilter) { _, error in
                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not a valid list of messages"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }
        }
    }
}
