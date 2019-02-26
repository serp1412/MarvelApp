struct APIResponse<T: Codable>: Codable {
    let data: T
}
