public struct Filter {
    public let id: Id

    public init(id: Id) {
        self.id = id
    }

    public typealias Id = UInt
}

extension Filter: Equatable {}
public func == (lhs: Filter, rhs: Filter) -> Bool {
    return lhs.id == rhs.id
}
