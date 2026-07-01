protocol PokemonRepository: Sendable {
    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon]
    func fetchDetail(id: Int) async throws -> PokemonDetail
}
