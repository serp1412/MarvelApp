struct APICollection<T: Codable>: Codable {
    let results: [T]
}
