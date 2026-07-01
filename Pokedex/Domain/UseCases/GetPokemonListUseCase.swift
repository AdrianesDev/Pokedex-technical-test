struct GetPokemonListUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func callAsFunction(limit: Int = 20, offset: Int = 0) async throws -> [Pokemon] {
        try await repository.fetchList(limit: limit, offset: offset)
    }
}
