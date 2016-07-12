import SwiftyJSON

public struct Message {
    public let payload: Payload
}

extension Message {
    init?(fromJson json: JSON) {
        guard let payloadString = json["payload"].string else {
            return nil
        }

        guard let payload = Payload(payloadString) else {
            return nil
        }

        self.payload = payload
    }
}
