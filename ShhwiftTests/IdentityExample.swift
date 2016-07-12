import Shhwift

extension Identity {

    static var example: Identity {
        let bytes = [UInt8](count: 65, repeatedValue: 0xda)
        return Identity(bytes)!
    }
}
