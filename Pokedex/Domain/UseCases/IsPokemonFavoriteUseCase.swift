struct IsPokemonFavoriteUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int) async -> Bool {
        await repository.isFavorite(id: id)
    }
}
