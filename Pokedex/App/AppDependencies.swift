/// Composition root: the one place in the app that knows about concrete
/// implementations (PokemonRepositoryImpl, APIClient, local storage).
/// Screens only receive use cases or view models built from here — they
/// never construct a repository themselves.
struct AppDependencies {
    let repository: PokemonRepository

    init(repository: PokemonRepository = PokemonRepositoryImpl(localDataSource: PokemonLocalDataSource())) {
        self.repository = repository
    }

    func makeListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))
    }

    func makeDetailViewModel(id: Int) -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            id: id,
            getPokemonDetail: GetPokemonDetailUseCase(repository: repository),
            getPokemonEvolutions: GetPokemonEvolutionsUseCase(repository: repository),
            toggleFavorite: ToggleFavoriteUseCase(repository: repository),
            isPokemonFavorite: IsPokemonFavoriteUseCase(repository: repository)
        )
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(getFavoritePokemon: GetFavoritePokemonUseCase(repository: repository))
    }
}
