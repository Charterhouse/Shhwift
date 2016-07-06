import Alamofire
import SwiftyJSON

struct JsonRpc {

    let url: String

    init(url: String) {
        self.url = url
    }

    func call(method method: String, parameters: JSON? = nil, callback: Callback) {

        var request: [String: AnyObject] = [
            "jsonrpc": "2.0",
            "method": method,
            "id": 0
        ]

        if let parameters = parameters {
            request["params"] = parameters.object
        }

        func success(result: JSON?) {
            callback(result: result, error: nil)
        }

        func failure(error: JsonRpcError) {
            callback(result: nil, error: error)
        }

        func completionHandler(response: Response<AnyObject, NSError>) {
            if let error = response.result.error {
                failure(.HttpFailed(cause: error))
                return
            }

            if let error = JSON(response.result.value)?["error"].dictionary {
                let code = error["code"]?.int ?? 0
                let message = error["message"]?.string ?? "Unknown Error"
                failure(.CallFailed(code: code, message: message))
                return
            }

            let result = JSON(response.result.value)?["result"]
            success(result)
        }

        Alamofire
            .request(.POST, url, parameters: request, encoding: .JSON)
            .validate()
            .responseJSON(completionHandler: completionHandler)
    }

    typealias Callback = (result: JSON?, error: JsonRpcError?) -> ()

}
