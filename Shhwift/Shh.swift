import Alamofire
import SwiftyJSON

public struct Shh {

    let url: String

    public init(url: String) {
        self.url = url
    }

    public func version(callback: VersionCallback) {

        let request = [
            "jsonrpc": "2.0",
            "method": "shh_version",
            "id": 0
        ]

        func completionHandler(response: Response<AnyObject, NSError>) {
            guard response.result.error == nil else {
                callback(version: nil, error: response.result.error)
                return
            }

            if let result = JSON(response.result.value)?["result"].string {
                callback(version: result, error: nil)
            }
        }

        Alamofire
            .request(.POST, url, parameters: request, encoding: .JSON)
            .validate()
            .responseJSON(completionHandler: completionHandler)

    }

    public typealias VersionCallback = (version: String?, error: ErrorType?)->()
}
