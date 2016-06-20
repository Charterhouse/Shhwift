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

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
}
