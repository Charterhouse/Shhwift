import XCTest
import Mockingjay
import SwiftyJSON
@testable import Shhwift

extension XCTest {

    func interceptRequests(to uri: String, handler: (NSURLRequest)->()) {
        func matcher(request: NSURLRequest) -> Bool {
            handler(request)
            return Mockingjay.uri(uri)(request: request)
        }

        self.stub(matcher, builder: http())
    }

    func stubRequests(to uri: String, result builder: Builder) {
        self.stub(Mockingjay.uri(uri), builder: builder)
    }
}

extension XCTest {

    func interceptJSONRequests(to uri: String, handler: (JSON?)->()) {
        interceptRequests(to: uri) { request in
            let json = JSON(data: request.HTTPBodyStream?.readFully())
            handler(json)
        }
    }
}
