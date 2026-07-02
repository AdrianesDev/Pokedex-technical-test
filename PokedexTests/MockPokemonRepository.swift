@testable import Pokedex

/// Test double with configurable results per method — lets each test
/// script exactly the scenario it wants (success, specific error, given
/// favorite state) without touching the network or local storage.
final class MockPokemonRepository: PokemonRepository, @unchecked Sendable {
    var listResult: Result<[Pokemon], Error> = .success([])
    var detailResult: Result<PokemonDetail, Error> = .failure(PokemonError.unknown)
    var evolutionsResult: Result<[PokemonEvolution], Error> = .success([])
    var favoriteIds: Set<Int> = []
    var favorites: [Pokemon] = []

    private(set) var toggleFavoriteCallCount = 0

    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon] {
        try listResult.get()
    }

    func fetchDetail(id: Int) async throws -> PokemonDetail {
        try detailResult.get()
    }

    func fetchEvolutions(id: Int) async throws -> [PokemonEvolution] {
        try evolutionsResult.get()
    }

    @discardableResult
    func toggleFavorite(_ pokemon: Pokemon) async -> Bool {
        toggleFavoriteCallCount += 1
        if favoriteIds.contains(pokemon.id) {
            favoriteIds.remove(pokemon.id)
        } else {
            favoriteIds.insert(pokemon.id)
        }
        return favoriteIds.contains(pokemon.id)
    }

    func isFavorite(id: Int) async -> Bool {
        favoriteIds.contains(id)
    }

    func fetchFavorites() async -> [Pokemon] {
        favorites
    }
}
