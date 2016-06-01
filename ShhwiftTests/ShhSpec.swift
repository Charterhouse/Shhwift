import Quick
import Nimble
import Mockingjay
import SwiftyJSON
@testable import Shhwift

class ShhSpec: QuickSpec {
    override func spec () {

        let url = "http://some.ethereum.node:8545"
        var shh: Shh!

        beforeEach {
            shh = Shh(url: url)
        }

        describe("version") {

            it("connects to the correct url") {
                waitUntil { done in

                    self.interceptRequests(to: url) { request in
                        expect(request.URL).to(equal(NSURL(string: url)))
                        done()
                    }

                    shh.version { _, _ in return }
                }
            }

            it("sends a JSON-RPC 2.0 request") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["jsonrpc"]).to(equal("2.0"))
                        done()
                    }

                    shh.version { _, _ in return }
                }
            }

            it("calls the shh_version JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]).to(equal("shh_version"))
                        done()
                    }

                    shh.version { _, _ in return }
                }
            }

            it("includes a JSON-RPC request id") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["id"]).toNot(beNil())
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
        }
    }
}
