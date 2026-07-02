struct GetFavoritePokemonUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func callAsFunction() async -> [Pokemon] {
        await repository.fetchFavorites()
    }
}
