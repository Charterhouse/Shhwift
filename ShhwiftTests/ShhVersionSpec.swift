import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhVersionSpec: QuickSpec {
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
    }
}
