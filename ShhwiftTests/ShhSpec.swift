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
                        expect(json?["method"]) == "shh_version"
                        done()
                    }

                    shh.version { _, _ in return }
                }
            }

            it("returns the correct result") {
                self.stubRequests(to: url, result: json(["result": "42.0"]))

                waitUntil { done in
                    shh.version { version, _ in
                        expect(version) == "42.0"
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

        describe("new identity") {

            it("calls the shh_newIdentity JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]) == "shh_newIdentity"
                        done()
                    }

                    shh.newIdentity { _, _ in return }
                }
            }

            it("returns the correct result") {
                let someIdentity = Identity.example

                self.stubRequests(
                    to: url,
                    result: json(["result": someIdentity.asHexString])
                )

                waitUntil { done in
                    shh.newIdentity { identity, _ in
                        expect(identity) == someIdentity
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                self.stubRequests(to: url, result: http(404))

                waitUntil { done in
                    shh.newIdentity { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies when result is not an identity string") {
                self.stubRequests(to: url, result: json(["result": "0xabcd"]))

                waitUntil { done in
                    shh.newIdentity { _, error in
                        let expectedError = ShhError.ShhFailed(
                            message: "Result is not an identity string"
                        )
                        expect(error) == expectedError
                        done()
                    }
                }
            }
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
