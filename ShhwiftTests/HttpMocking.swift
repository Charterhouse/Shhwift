import XCTest
import Mockingjay

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
