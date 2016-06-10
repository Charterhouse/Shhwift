import Alamofire
import SwiftyJSON

public struct Shh {

    let rpc: JsonRpc

    public init(url: String) {
        self.rpc = JsonRpc(url: url)
    }

    public func version(callback: VersionCallback) {
        rpc.call(method: "shh_version") { result, error in

            if let error = error {
                callback(version: nil, error: .JsonRpcFailed(cause: error))
                return
            }

            guard let version = result?.string else {
                callback(version: nil, error: .ShhFailed(message: "Result is not a string"))
                return
            }

            callback(version: version, error: nil)

        }
    }

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
}
