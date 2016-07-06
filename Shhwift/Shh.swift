import Alamofire
import SwiftyJSON

public struct Shh {

    let rpc: JsonRpc

    public init(url: String) {
        self.rpc = JsonRpc(url: url)
    }

    public func version(callback: VersionCallback) {

        func failure(error: ShhError) {
            callback(version: nil, error: error)
        }

        func success(version: String) {
            callback(version: version, error: nil)
        }

        rpc.call(method: "shh_version") { result, error in

            if let error = error {
                failure(.JsonRpcFailed(cause: error))
                return
            }

            guard let version = result?.string else {
                failure(.ShhFailed(message: "Result is not a string"))
                return
            }

            success(version)
        }
    }

    public func post(from sender: Identity? = nil, to receiver: Identity? = nil,
                          callback: PostCallback) {

        var post = [String: String]()

        if let sender = sender {
            post["from"] = sender.asHexString
        }

        if let receiver = receiver {
            post["to"] = receiver.asHexString
        }

        rpc.call(method: "shh_post", parameters: JSON([post])) { _, _ in }
    }

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
    public typealias PostCallback = (success: Bool?, error: ShhError?) -> ()
}
