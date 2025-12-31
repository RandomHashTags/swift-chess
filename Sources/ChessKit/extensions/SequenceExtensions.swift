

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

// MARK: InlineArray
extension InlineArray {
    public subscript(_ index: some FixedWidthInteger) -> Element {
        _read {
            yield self[Int(index)]
        }
        _modify {
            yield &self[Int(index)]
        }
    }
}