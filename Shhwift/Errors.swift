public enum ShhError {
    case JsonRpcFailed(cause: JsonRpcError)
    case ShhFailed(message: String)
}

public enum JsonRpcError: ErrorType {
    case HttpFailed(cause: NSError)
    case CallFailed(code: Int, message: String)
}

extension ShhError: CustomStringConvertible {
    public var description: String {
        switch self {
        case JsonRpcFailed(let cause):
            return "[JSON-RPC failed: cause:\(cause)]"
        case ShhFailed(let message):
            return "[Shh failed: message:\(message)]"
        }
    }
}

extension JsonRpcError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .HttpFailed(let cause):
            return "[HTTP failed: cause:\(cause)]"
        case .CallFailed(let code, let message):
            return "[Call failed: code:\(code), message:\(message)]"
        }
    }
}

extension ShhError: Equatable {}
public func == (lhs: ShhError, rhs: ShhError) -> Bool {
    switch (lhs, rhs) {
    case (
        .JsonRpcFailed(let lhsCause),
        .JsonRpcFailed(let rhsCause)
        ):
        return lhsCause == rhsCause
    case (
        .ShhFailed(let lhsMessage),
        .ShhFailed(let rhsMessage)
        ):
        return lhsMessage == rhsMessage
    default:
        return false
    }
}

extension JsonRpcError: Equatable {}
public func == (lhs: JsonRpcError, rhs: JsonRpcError) -> Bool {
    switch (lhs, rhs) {
    case (
        .HttpFailed(let lhsCause),
        .HttpFailed(let rhsCause)
        ):
        return lhsCause == rhsCause
    case (
        .CallFailed(let lhsCode, let lhsMessage),
        .CallFailed(let rhsCode, let rhsMessage)
        ):
        return lhsCode == rhsCode && lhsMessage == rhsMessage
    default:
        return false
    }
}
