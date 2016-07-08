import Quick
import Nimble
import Mockingjay
import SwiftyJSON
import Shhwift

class ShhNewIdentitySpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
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
    }
}
