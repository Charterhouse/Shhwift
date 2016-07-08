public extension Shh {

    public func newIdentity(callback: IdentityCallback) {
        rpc.call(method: "shh_newIdentity") { result, error in

            func failed(error: ShhError) {
                callback(identity: nil, error: error)
            }

            func succeeded(identity: Identity) {
                callback(identity: identity, error: nil)
            }

            if let error = error {
                failed(.JsonRpcFailed(cause: error))
                return
            }

            guard let identity = Identity(result?.string) else {
                failed(.ShhFailed(message: "Result is not an identity string"))
                return
            }

            succeeded(identity)
        }
    }

    public typealias IdentityCallback =
        (identity: Identity?, error: ShhError?)->()
}

private extension Identity {
    init?(_ hexString: String?) {
        guard let hexString = hexString else {
            return nil
        }

        self.init(hexString)
    }
}
