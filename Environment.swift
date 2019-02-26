struct Environment {
    let api: APIType

    init(api: APIType = API()) {
        self.api = api
    }
}
