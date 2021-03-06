import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhPostSpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
        }

        describe("post") {

            let topics = [Topic.example, Topic.example]
            let payload = Payload.example
            let priority: Post.MillisecondsOfProcessingTime = 500
            let timeToLive: Post.Seconds = 600

            let post = Post(
                topics: topics,
                payload: payload,
                priority: priority,
                timeToLive: timeToLive
            )

            func checkJsonRpcCall(for post: Post, check: (JSON?) -> ()) {
                waitUntil { done in
                    self.interceptJSONRequests(to: url) { json in
                        check(json)
                        done()
                    }
                    shh.post(post) { _, _ in return }
                }
            }

            it("calls the shh_post JSON-RPC method") {
                checkJsonRpcCall(for: post) { json in
                    expect(json?["method"]) == "shh_post"
                }
            }

            it("adds the sender") {
                let sender = Identity.example

                let postWithSender = Post(
                    from: sender,
                    topics: topics,
                    payload: payload,
                    priority: priority,
                    timeToLive: timeToLive
                )

                checkJsonRpcCall(for: postWithSender) { json in
                    let jsonSender = json?["params"][0]["from"]
                    expect(jsonSender) == JSON(sender.asHexString)
                }
            }

            it("adds the receiver") {
                let receiver = Identity.example

                let postWithReceiver = Post(
                    to: receiver,
                    topics: topics,
                    payload: payload,
                    priority: priority,
                    timeToLive: timeToLive
                )

                checkJsonRpcCall(for: postWithReceiver) { json in
                    let jsonSender = json?["params"][0]["to"]
                    expect(jsonSender) == JSON(receiver.asHexString)
                }
            }

            it("adds the topics") {
                checkJsonRpcCall(for: post) { json in
                    let jsonTopics = json?["params"][0]["topics"]
                    expect(jsonTopics) == JSON(topics.map { $0.asHexString })
                }
            }

            it("adds the payload") {
                checkJsonRpcCall(for: post) { json in
                    let jsonPayload = json?["params"][0]["payload"]
                    expect(jsonPayload) == JSON(payload.asHexString)
                }
            }

            it("adds the priority") {
                checkJsonRpcCall(for: post) { json in
                    let jsonPriority = json?["params"][0]["priority"]
                    expect(jsonPriority) == JSON(priority.asHexString)
                }
            }

            it("adds the time to live") {
                checkJsonRpcCall(for: post) { json in
                    let jsonTimeToLive = json?["params"][0]["ttl"]
                    expect(jsonTimeToLive) == JSON(timeToLive.asHexString)
                }
            }

            it("returns success boolean") {
                self.stubRequests(to: url, result: json(["result": true]))

                waitUntil { done in
                    shh.post(post) { success, _ in

                        expect(success) == true
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                self.stubRequests(to: url, result: http(404))

                waitUntil { done in
                    shh.post(post) { _, error in

                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies when result is not a boolean") {
                self.stubRequests(to: url, result: json([]))

                waitUntil { done in
                    shh.post(post) { _, error in

                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not a boolean"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }
        }
    }
}
