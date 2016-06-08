import XCTest
import Mockingjay
import SwiftyJSON
import Shhwift

extension XCTest {

    func interceptRequests(to uri: String, handler: (NSURLRequest)->()) {
        func builder(request: NSURLRequest) -> Response {
            handler(request)
            return http()(request: request)
        }

        self.stub(Mockingjay.uri(uri), builder: builder)
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
