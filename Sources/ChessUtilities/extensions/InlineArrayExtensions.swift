
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