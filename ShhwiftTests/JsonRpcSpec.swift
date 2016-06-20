//  Copyright © 2016 Shhwift. All rights reserved.

import Quick
import Nimble
import Mockingjay
@testable import Shhwift

class JsonRcpSpec: QuickSpec {
    override func spec() {

        let url = "http://some.rpc.json.server"
        var jsonRpc: JsonRpc!

        beforeEach {
            jsonRpc = JsonRpc(url: url)
        }

        describe("call") {

            it("connects to the correct url") {
                waitUntil { done in

                    self.interceptRequests(to: url) { request in
                        expect(request.URL).to(equal(NSURL(string: url)))
                        done()
                    }

                    jsonRpc.call(method: "") { _, _ in }
                }
            }

            it("sends a JSON-RPC 2.0 request") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["jsonrpc"]).to(equal("2.0"))
                        done()
                    }

                    jsonRpc.call(method: "") { _, _ in }
                }
            }

            it("includes a JSON-RPC request id") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["id"]).toNot(beNil())
                        done()
                    }

                    jsonRpc.call(method: "") { _, _ in }
                }
            }

            it("calls the correct JSON-RPC method") {
                waitUntil { done in

                    self.interceptJSONRequests(to: url) { json in
                        expect(json?["method"]).to(equal("some_method"))
                        done()
                    }

                    jsonRpc.call(method: "some_method") { _, _ in }
                }
            }

            it("returns the correct result") {
                self.stubRequests(to: url, result: json(["result": 42]))

                waitUntil { done in
                    jsonRpc.call(method: "") { result, _ in
                        expect(result).to(equal(42))
                        done()
                    }
                }
            }

            it("notifies about connection errors") {
                let connectionError = NSError(
                    domain: NSURLErrorDomain,
                    code: NSURLErrorUnknown,
                    userInfo: nil
                )

                self.stubRequests(to: url, result: failure(connectionError))

                waitUntil { done in
                    jsonRpc.call(method: "") { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies about HTTP errors") {
                self.stubRequests(to: url, result: json([], status:404))

                waitUntil { done in
                    jsonRpc.call(method: "") { _, error in
                        expect(error).toNot(beNil())
                        done()
                    }
                }
            }

            it("notifies about JSON-RPC errors") {
                let code = -12345
                let message = "Something went wrong"

                self.stubRequests(
                    to: url,
                    result: json(["error": ["code": code, "message": message]])
                )

                let expectedError = JsonRpcError.CallFailed(
                    code: code,
                    message:message
                )

                waitUntil { done in
                    jsonRpc.call(method: "") { _, error in
                        expect(error) == expectedError
                        done()
                    }
                }
            }
        }
    }
}
