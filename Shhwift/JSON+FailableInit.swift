import SwiftyJSON

extension JSON {

    init?(_ possibleObject: AnyObject?) {
        guard let object = possibleObject else {
            return nil
        }

        self.init(object)
    }

    init?(data possibleData: NSData?) {
        guard let data = possibleData else {
            return nil
        }

        self.init(data: data)
    }
}
