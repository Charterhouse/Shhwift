public struct Post {
    public let sender: Identity?
    public let receiver: Identity?
    public let topics: [Topic]
    public let payload: Payload
    public let priority: MillisecondsOfProcessingTime
    public let timeToLive: Seconds

    public init(from sender: Identity? = nil, to receiver: Identity? = nil,
                     topics: [Topic], payload: Payload,
                     priority: MillisecondsOfProcessingTime,
                     timeToLive: Seconds) {

        self.sender = sender
        self.receiver = receiver
        self.topics = topics
        self.payload = payload
        self.priority = priority
        self.timeToLive = timeToLive
    }

    public typealias MillisecondsOfProcessingTime = UInt
    public typealias Seconds = UInt
}
