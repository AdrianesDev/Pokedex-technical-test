import Testing
@testable import Pokedex

@MainActor
struct PokemonListViewModelTests {
    @Test func loadInitialPopulatesPokemonAndSetsLoadedState() async {
        let repository = MockPokemonRepository()
        repository.listResult = .success([
            Pokemon(id: 1, name: "bulbasaur", imageURL: nil, types: ["grass", "poison"]),
            Pokemon(id: 4, name: "charmander", imageURL: nil, types: ["fire"])
        ])
        let viewModel = PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))

        await viewModel.loadInitial()

        #expect(viewModel.state == .loaded)
        #expect(viewModel.pokemon.count == 2)
    }

    @Test func loadInitialWithEmptyResultSetsEmptyState() async {
        let repository = MockPokemonRepository()
        repository.listResult = .success([])
        let viewModel = PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))

        await viewModel.loadInitial()

        #expect(viewModel.state == .empty)
    }

    @Test func loadInitialWithConnectivityErrorSetsErrorState() async {
        let repository = MockPokemonRepository()
        repository.listResult = .failure(PokemonError.connectivity)
        let viewModel = PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))

        await viewModel.loadInitial()

        #expect(viewModel.state == .error("Revisa tu conexión a internet e intenta de nuevo."))
    }

    @Test func filteredPokemonCombinesCategoryAndSearch() async {
        let repository = MockPokemonRepository()
        repository.listResult = .success([
            Pokemon(id: 1, name: "bulbasaur", imageURL: nil, types: ["grass", "poison"]),
            Pokemon(id: 4, name: "charmander", imageURL: nil, types: ["fire"]),
            Pokemon(id: 7, name: "squirtle", imageURL: nil, types: ["water"])
        ])
        let viewModel = PokemonListViewModel(getPokemonList: GetPokemonListUseCase(repository: repository))
        await viewModel.loadInitial()

        viewModel.selectType("fire")
        #expect(viewModel.filteredPokemon.map(\.name) == ["charmander"])

        // tapping the same chip again ("Todos" behavior) clears the filter
        viewModel.selectType("fire")
        #expect(viewModel.filteredPokemon.count == 3)

        viewModel.searchText = "squi"
        #expect(viewModel.filteredPokemon.map(\.name) == ["squirtle"])
    }
}
