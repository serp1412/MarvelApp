@testable import MarvelAppFramework

protocol MockableModel {
    static func mocked() -> Self
}

extension APICollection: MockableModel where T: MockableModel {
    static func mocked() -> APICollection<T> {
        return mocked(results: [])
    }

    static func mocked(results: [T] = [.mocked()], offset: Int = 0, limit: Int = 20, total: Int = 100, count: Int = 0) -> APICollection<T> {
        return .init(results: results,
                     offset: offset,
                     limit: limit,
                     total: total,
                     count: count)
    }
}
