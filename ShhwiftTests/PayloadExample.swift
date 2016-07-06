import Shhwift

extension Payload {

    static var example: Payload {
        return Payload("payload".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}
