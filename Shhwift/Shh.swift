import Alamofire
import SwiftyJSON

public struct Shh {

    let url: String

    public init(url: String) {
        self.url = url
    }

    public func version(callback: (version: String?, error: ErrorType?) -> ()) {
        Alamofire.request(.POST, "http://some.ethereum.node:8545").responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                if let result = json["result"].string {
                    callback(version: result, error: nil)
                }
            }
        }
    }
}
