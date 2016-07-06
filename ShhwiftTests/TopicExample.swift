import Shhwift

extension Topic {

    static var example: Topic {
        let bytes = [UInt8](count: 32, repeatedValue: 0xbe)
        return Topic(bytes)!
    }
}
