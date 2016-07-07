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

    public func post(from sender: Identity? = nil,
                     to receiver: Identity? = nil,
                     topics: [Topic],
                     payload: Payload,
                     priority: MillisecondsOfProcessingTime,
                     timeToLive: Seconds,
                     callback: PostCallback) {

        func failed(error: ShhError) {
            callback(success: nil, error: error)
        }

        func succeeded(success: Bool?) {
            callback(success: success, error: nil)
        }

        let post = createPost(
            from: sender,
            to: receiver,
            topics: topics,
            payload: payload,
            priority: priority,
            timeToLive: timeToLive
        )

        rpc.call(method: "shh_post", parameters: JSON([post])) { result, error in
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

    private func createPost(from sender: Identity? = nil,
                            to receiver: Identity? = nil,
                            topics: [Topic],
                            payload: Payload,
                            priority: MillisecondsOfProcessingTime,
                            timeToLive: Seconds) -> [String: AnyObject] {

        var post = [String: AnyObject]()
        if let sender = sender {
            post["from"] = sender.asHexString
        }
        if let receiver = receiver {
            post["to"] = receiver.asHexString
        }
        post["topics"] = topics.map { $0.asHexString }
        post["payload"] = payload.asHexString
        post["priority"] = priority.asHexString
        post["ttl"] = timeToLive.asHexString

        return post
    }

    public typealias VersionCallback = (version: String?, error: ShhError?)->()
    public typealias PostCallback = (success: Bool?, error: ShhError?) -> ()
    public typealias MillisecondsOfProcessingTime = UInt
    public typealias Seconds = UInt
}
