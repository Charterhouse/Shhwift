import SwiftyJSON

public extension Shh {

    public func getFilterChanges(filter: Filter, callback: MessagesCallback) {

        let parameters = JSON([filter.id.asHexString])

        rpc.call(method: "shh_getFilterChanges", parameters: parameters) { result, error in

            func succeeded(messages: [Message]) {
                callback(messages: messages, error: nil)
            }

            func failed(error: ShhError) {
                callback(messages: nil, error: error)
            }

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            let messagesAsJson = result?.array
            let parsedMessages = messagesAsJson?.flatMap({ Message(fromJson: $0) })

            guard let messages = parsedMessages else {
                failed(.ShhFailed(message: "Result is not a valid list of messages"))
                return
            }

            guard messages.count == messagesAsJson?.count else {
                failed(.ShhFailed(message: "Result is not a valid list of messages"))
                return
            }

            succeeded(messages)
        }
    }

    public typealias MessagesCallback = (messages: [Message]?, error: ShhError?) -> ()
}
