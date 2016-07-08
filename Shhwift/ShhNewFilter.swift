import SwiftyJSON

public extension Shh {

    public func newFilter(topics topics: [Topic],
                                 receiver: Identity? = nil,
                                 callback: NewFilterCallback) {

        let creation = FilterCreation(topics: topics, receiver: receiver)
        let parameters = JSON([creation.asDictionary])

        rpc.call(method: "shh_newFilter", parameters: parameters) { result, error in

            func failed(error: ShhError) {
                callback(filter: nil, error: error)
            }

            func succeeded(filter: Filter) {
                callback(filter: filter, error: nil)
            }

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let filterId = Filter.Id(hexString: result?.string) else {
                failed(.ShhFailed(message: "Result is not a valid filter id"))
                return
            }

            succeeded(Filter(id: filterId))
        }
    }

    public typealias NewFilterCallback =
        (filter: Filter?, error: ShhError?)->()
}

private struct FilterCreation {
    let topics: [Topic]
    let receiver: Identity?
}

extension FilterCreation {
    var asDictionary: [String: AnyObject] {
        var result = [String: AnyObject]()
        if let receiver = receiver {
            result["to"] = receiver.asHexString
        }
        result["topics"] = topics.map { $0.asHexString }
        return result
    }
}

private extension Filter.Id {
    init?(hexString: String?) {
        guard let hexString = hexString else {
            return nil
        }

        self.init(hexString: hexString)
    }
}
