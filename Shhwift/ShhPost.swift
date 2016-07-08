import SwiftyJSON

public extension Shh {

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

    public typealias PostCallback =
        (success: Bool?, error: ShhError?) -> ()
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
