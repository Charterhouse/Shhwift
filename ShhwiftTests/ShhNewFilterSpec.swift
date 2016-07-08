import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhNewFilterSpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
        }

        describe("new filter") {

            let topics = [Topic.example, Topic.example]
            let receiver = Identity.example

            it("calls the shh_newFilter JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]) == "shh_newFilter"
                        done()
                    }

                    shh.newFilter(topics: topics) { _, _ in return }
                }
            }

            it("adds the topics") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        let jsonTopics = json?["params"][0]["topics"]
                        expect(jsonTopics) == JSON(topics.map { $0.asHexString })
                        done()
                    }

                    shh.newFilter(topics: topics) { _, _ in return }
                }
            }

            it("adds the receiver") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        let jsonReceiver = json?["params"][0]["to"]
                        expect(jsonReceiver) == JSON(receiver.asHexString)
                        done()
                    }

                    shh.newFilter(topics: topics, receiver: receiver) { _, _ in
                        return
                    }
                }
            }

            it("returns the correct result") {
                let someFilter = Filter.example

                self.stubRequests(
                    to: url,
                    result: json(["result": someFilter.id.asHexString])
                )

                waitUntil { done in
                    shh.newFilter(topics: topics) { filter, _ in
                        expect(filter) == someFilter
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                self.stubRequests(to: url, result: http(404))

                waitUntil { done in
                    shh.newFilter(topics: topics) { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies when result is not a filter id string") {
                self.stubRequests(to: url, result: json(["result": "0xZZ"]))

                waitUntil { done in
                    shh.newFilter(topics: topics) { _, error in
                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not a valid filter id"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }
        }
    }
}
