import Alamofire
import SwiftyJSON

public struct Shh {

    let rpc: JsonRpc

    public init(url: String) {
        self.rpc = JsonRpc(url: url)
    }

    public func version(callback: VersionCallback) {

        func failed(error: ShhError) {
            callback(version: nil, error: error)
        }

        func succeeded(version: String) {
            callback(version: version, error: nil)
        }

        rpc.call(method: "shh_version") { result, error in

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let version = result?.string else {
                failed(.ShhFailed(message: "Result is not a string"))
                return
            }

            succeeded(version)
        }
    }

    public func post(post: Post, callback: PostCallback) {

        func failed(error: ShhError) {
            callback(success: nil, error: error)
        }

        func succeeded(success: Bool?) {
            callback(success: success, error: nil)
        }

        let parameters = JSON([post.asDictionary])

        rpc.call(method: "shh_post", parameters: parameters) { result, error in

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let success = result?.bool else {
                failed(.ShhFailed(message: "Result is not a boolean"))
                return
            }

            succeeded(success)
        }
    }

    public func newIdentity(callback: IdentityCallback) {
        rpc.call(method: "shh_newIdentity") { result, error in

            func failed(error: ShhError) {
                callback(identity: nil, error: error)
            }

            func succeeded(identity: Identity) {
                callback(identity: identity, error: nil)
            }

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let identity = Identity(result?.string) else {
                failed(.ShhFailed(message: "Result is not an identity string"))
                return
            }

            succeeded(identity)
        }
    }

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
    public typealias PostCallback = (success: Bool?, error: ShhError?) -> ()
    public typealias IdentityCallback = (identity: Identity?, error: ShhError?)->()
}

private extension Post {
    var asDictionary: [String: AnyObject] {

        var result = [String: AnyObject]()

        if let sender = sender {
            result["from"] = sender.asHexString
        }

        if let receiver = receiver {
            result["to"] = receiver.asHexString
        }

        result["topics"] = topics.map { $0.asHexString }
        result["payload"] = payload.asHexString
        result["priority"] = priority.asHexString
        result["ttl"] = timeToLive.asHexString

        return result
    }
}

private extension Identity {
    init?(_ hexString: String?) {
        guard let hexString = hexString else {
            return nil
        }

        self.init(hexString)
    }
}
