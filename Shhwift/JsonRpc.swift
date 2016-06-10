import Alamofire
import SwiftyJSON

struct JsonRpc {

    let url: String

    init(url: String) {
        self.url = url
    }

    func call(method method: String, callback: Callback) {

        let request: [String: AnyObject] = [
            "jsonrpc": "2.0",
            "method": method,
            "id": 0
        ]

        func completionHandler(response: Response<AnyObject, NSError>) {
            if let error = response.result.error {
                callback(
                    result: nil,
                    error: JsonRpcError.HttpFailed(cause: error)
                )
                return
            }

            if let error = JSON(response.result.value)?["error"].dictionary {
                let code = error["code"]?.int ?? 0
                let message = error["message"]?.string ?? "Unknown Error"
                callback(
                    result: nil,
                    error: JsonRpcError.CallFailed(code: code, message: message)
                )
                return
            }

            let result = JSON(response.result.value)?["result"]
            callback(result: result, error: nil)
        }

        Alamofire
            .request(.POST, url, parameters: request, encoding: .JSON)
            .validate()
            .responseJSON(completionHandler: completionHandler)
    }

    typealias Callback = (result: JSON?, error: JsonRpcError?) -> ()

}
