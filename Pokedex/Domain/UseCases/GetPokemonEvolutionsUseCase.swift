struct GetPokemonEvolutionsUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> [PokemonEvolution] {
        try await repository.fetchEvolutions(id: id)
    }
}
