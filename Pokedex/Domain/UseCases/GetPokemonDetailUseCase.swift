struct GetPokemonDetailUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async throws -> PokemonDetail {
        try await repository.fetchDetail(id: id)
    }
}
