import XCTest
import Mockingjay

extension XCTest {

    func interceptRequests(handler: (NSURLRequest)->()) {
        func matcher(request: NSURLRequest) -> Bool {
            handler(request)
            return true
        }

        self.stub(matcher, builder: http())
    }

    func stubRequests(result builder: Builder) {
        self.stub(everything, builder: builder)
    }
}
