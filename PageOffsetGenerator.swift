struct PageOffsetGenerator {
    private let maxItemsCount: Int
    private let pageSize: Int
    private var currentOffset = 0

    var allPagesLoaded: Bool {
        return maxItemsCount <= currentOffset - pageSize
    }

    init(pageSize: Int = 0, maxItemsCount: Int = 0) {
        self.pageSize = pageSize
        self.maxItemsCount = maxItemsCount
    }

    mutating func next() -> Int {
        currentOffset += pageSize
        return currentOffset
    }

    mutating func rewind() {
        currentOffset -= pageSize
    }
}
