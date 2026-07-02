/// The one seam between Domain and everything else — ViewModels only ever
/// talk to this, never to the network or local storage directly.
protocol PokemonRepository: Sendable {
    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon]
    func fetchDetail(id: Int) async throws -> PokemonDetail
    func fetchEvolutions(id: Int) async throws -> [PokemonEvolution]

    /// Returns the new favorite state.
    @discardableResult
    func toggleFavorite(_ pokemon: Pokemon) async -> Bool
    func isFavorite(id: Int) async -> Bool
    func fetchFavorites() async -> [Pokemon]
}
