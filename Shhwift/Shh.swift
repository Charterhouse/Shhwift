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
            if let error = response.result.error {
                callback(
                    version: nil,
                    error: ShhError.HttpFailure(cause: error)
                )
                return
            }

            if let error = JSON(response.result.value)?["error"].dictionary {
                let code = error["code"]?.int ?? 0
                let message = error["message"]?.string ?? "Unknown Error"
                callback(
                    version: nil,
                    error: ShhError.JsonRpcFailure(code: code, message: message)
                )
                return
            }

            guard let result = JSON(response.result.value)?["result"].string else {
                callback(
                    version: nil,
                    error: ShhError.ShhFailure(message: "Result is not a string")
                )
                return
            }

            callback(version: result, error: nil)
        }

        Alamofire
            .request(.POST, url, parameters: request, encoding: .JSON)
            .validate()
            .responseJSON(completionHandler: completionHandler)

    }

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
}
