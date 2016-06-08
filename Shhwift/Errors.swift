public enum ShhError {
    case HttpFailure(cause: NSError)
    case JsonRpcFailure(code: Int, message: String)
    case ShhFailure(message: String)
}

extension ShhError: CustomStringConvertible {
    public var description: String {
        switch self {
        case HttpFailure(let cause):
            return "[Shh HTTP Failure cause:\(cause)]"
        case JsonRpcFailure(let code, let message):
            return "[Shh JSON-RPC Failure code:\(code), message:\(message)]"
        case ShhFailure(let message):
            return "[Shh Failure message:\(message)]"
        }
    }
}

extension ShhError: Equatable {}
public func == (lhs: ShhError, rhs: ShhError) -> Bool {
    switch (lhs, rhs) {
    case (
        .HttpFailure(let lhsCause),
        .HttpFailure(let rhsCause)
        ):
        return lhsCause == rhsCause
    case (
        .JsonRpcFailure(let lhsCode, let lhsMessage),
        .JsonRpcFailure(let rhsCode, let rhsMessage)
        ):
        return lhsCode == rhsCode && lhsMessage == rhsMessage
    case (
        .ShhFailure(let lhsMessage),
        .ShhFailure(let rhsMessage)
        ):
        return lhsMessage == rhsMessage
    default:
        return false
    }
}
