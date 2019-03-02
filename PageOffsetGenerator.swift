struct PageOffsetGenerator {
    private let maxItemsCount: Int
    private let pageSize: Int
    private var currentOffset = 0

    var allPagesLoaded: Bool {
        return maxItemsCount <= currentOffset
    }

    init(pageSize: Int = 0,
         maxItemsCount: Int = 0,
         currentOffset: Int = 0) {
        self.pageSize = pageSize
        self.maxItemsCount = maxItemsCount
        self.currentOffset = currentOffset
    }

    mutating func next() -> Int {
        let copy = currentOffset
        currentOffset += pageSize
        return copy
    }

    mutating func rewind() {
        currentOffset -= pageSize
    }
}
