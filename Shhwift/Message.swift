import SwiftyJSON

public struct Message {
    public let topics: [Topic]
    public let payload: Payload
}

extension Message {
    init?(fromJson json: JSON) {
        guard let topicStrings = json["topics"].arrayObject as? [String] else {
            return nil
        }

        let topics = topicStrings.flatMap { Topic($0) }

        guard topicStrings.count == topics.count else {
            return nil
        }

        guard let payloadString = json["payload"].string else {
            return nil
        }

        guard let payload = Payload(payloadString) else {
            return nil
        }

        self.topics = topics
        self.payload = payload
    }
}
