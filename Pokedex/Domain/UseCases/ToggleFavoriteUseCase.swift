struct ToggleFavoriteUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    @discardableResult
    func callAsFunction(_ pokemon: Pokemon) async -> Bool {
        await repository.toggleFavorite(pokemon)
    }
}
