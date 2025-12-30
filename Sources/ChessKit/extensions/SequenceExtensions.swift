

// MARK: Set
extension Set {
    mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows {
        for element in self {
            if try predicate(element) {
                remove(element)
            }
        }
    }
}