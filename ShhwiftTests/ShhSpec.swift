import Quick
import Nimble
import Shhwift
import Mockingjay
import Alamofire

class ShhSpec: QuickSpec {
    override func spec () {

        it("requests version") {
            self.stub(
                http(.POST, uri:"http://some.ethereum.node:8545"),
                builder: json(["result": "42.0"])
            )

            waitUntil { done in
                Shh(url: "http://some.ethereum.node:8545").version { version, error in
                    expect(version).to(equal("42.0"))
                    done()
                }
            }

        }
    }
}
