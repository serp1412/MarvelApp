struct APICollection<T: Codable>: Codable {
    let results: [T]
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
}
