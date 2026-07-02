/// Composition root: the one place in the app that knows about concrete
/// implementations (PokemonRepositoryImpl, APIClient). Screens only receive
/// use cases or view models built from here — they never construct a
/// repository themselves.
struct AppDependencies {
    let repository: PokemonRepository

    init(repository: PokemonRepository = PokemonRepositoryImpl()) {
        self.repository = repository
    }

    func makeListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))
    }

    func makeDetailViewModel(id: Int) -> PokemonDetailViewModel {
        PokemonDetailViewModel(id: id, getPokemonDetail: GetPokemonDetailUseCase(repository: repository))
    }
}
