import Quick
import Nimble
import Shhwift
import Mockingjay
import Alamofire

class ShhSpec: QuickSpec {
    override func spec () {
        it("can be created") {
            _ = Shh()
        }

        it("can mock http requests") {
            let body = ["result": "42.0"]
            self.stub(
                http(.GET, uri: "http://some.ethereum.node:8545"),
                builder: json(body)
            )

            waitUntil { done in
                Alamofire.request(.GET, "http://some.ethereum.node:8545").responseJSON { response in
                    expect(response.result.error).to(beNil())
                    done()
                }
            }
        }
    }
}
