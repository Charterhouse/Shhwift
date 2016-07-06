import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhSpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
        }

        describe("version") {

            it("calls the shh_version JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]).to(equal("shh_version"))
                        done()
                    }

                    shh.version { _, _ in return }
                }
            }

            it("returns the correct result") {
                self.stubRequests(to: url, result: json(["result": "42.0"]))

                waitUntil { done in
                    shh.version { version, _ in
                        expect(version).to(equal("42.0"))
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                self.stubRequests(to: url, result: http(404))

                waitUntil { done in
                    shh.version { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies when result is not a string") {
                self.stubRequests(to: url, result: json([]))

                waitUntil { done in
                    shh.version { _, error in
                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not a string"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }
        }

        describe("post") {

            let topics = [Topic.example, Topic.example]

            it("calls the shh_post JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]).to(equal("shh_post"))
                        done()
                    }

                    shh.post(topics: topics) { _, _ in return }
                }
            }

            it("adds the sender") {
                let sender = Identity.example

                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        let jsonSender = json?["params"][0]["from"]
                        expect(jsonSender) == JSON(sender.asHexString)
                        done()
                    }

                    shh.post(from: sender, topics: topics) { _, _ in return }
                }
            }

            it("adds the receiver") {
                let receiver = Identity.example

                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        let jsonReceiver = json?["params"][0]["to"]
                        expect(jsonReceiver) == JSON(receiver.asHexString)
                        done()
                    }

                    shh.post(to: receiver, topics: topics) { _, _ in return }
                }
            }

            it("adds the topics") {
                waitUntil { done in
                    self.interceptJSONRequests(to: url) { json in
                        let jsonTopics = json?["params"][0]["topics"]
                        expect(jsonTopics) == JSON(topics.map { $0.asHexString })
                        done()
                    }

                    shh.post(topics: topics) { _, _ in return }
                }
            }
        }
    }
}
