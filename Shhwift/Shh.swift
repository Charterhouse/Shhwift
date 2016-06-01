import Alamofire
import SwiftyJSON

public struct Shh {

    let url: String

    public init(url: String) {
        self.url = url
    }

    public func version(callback: VersionCallback) {

        let request = [
            "jsonrpc": "2.0"
        ]

        func handleResponse(response: Response<AnyObject, NSError>) {
            if let json = response.result.value,
                let result = JSON(json)["result"].string
            {
                callback(version: result, error: nil)
            }
        }

        Alamofire
            .request(.POST, url, parameters: request, encoding: .JSON)
            .responseJSON(completionHandler: handleResponse)

    }

    public typealias VersionCallback = (version: String?, error: ErrorType?)->()
}
