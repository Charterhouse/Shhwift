public extension Shh {

    public func version(callback: VersionCallback) {

        func failed(error: ShhError) {
            callback(version: nil, error: error)
        }

        func succeeded(version: String) {
            callback(version: version, error: nil)
        }

        rpc.call(method: "shh_version") { result, error in

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let version = result?.string else {
                failed(.ShhFailed(message: "Result is not a string"))
                return
            }

            succeeded(version)
        }
    }

    public typealias VersionCallback =
        (version: String?, error: ShhError?)->()
}
