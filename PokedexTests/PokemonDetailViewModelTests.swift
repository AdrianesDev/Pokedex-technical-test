import Testing
@testable import Pokedex

@MainActor
struct PokemonDetailViewModelTests {
    @Test func loadPopulatesDetailEvolutionsAndFavoriteStatusIndependently() async {
        let repository = MockPokemonRepository()
        repository.detailResult = .success(Self.detail)
        repository.evolutionsResult = .success([PokemonEvolution(id: 1, name: "bulbasaur", imageURL: nil)])
        repository.favoriteIds = [1]
        let viewModel = Self.makeViewModel(id: 1, repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .loaded(Self.detail))
        #expect(viewModel.evolutionsState == .loaded([PokemonEvolution(id: 1, name: "bulbasaur", imageURL: nil)]))
        #expect(viewModel.isFavorite == true)
    }

    @Test func toggleFavoriteFlipsStateAndDelegatesToUseCase() async {
        let repository = MockPokemonRepository()
        repository.detailResult = .success(Self.detail)
        let viewModel = Self.makeViewModel(id: 1, repository: repository)
        await viewModel.load()
        #expect(viewModel.isFavorite == false)

        await viewModel.toggleFavorite()

        #expect(viewModel.isFavorite == true)
        #expect(repository.toggleFavoriteCallCount == 1)
    }

    @Test func loadWithNotFoundErrorSetsErrorState() async {
        let repository = MockPokemonRepository()
        repository.detailResult = .failure(PokemonError.notFound)
        let viewModel = Self.makeViewModel(id: 999, repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .error("No se encontró este Pokémon."))
    }

    private static var detail: PokemonDetail {
        PokemonDetail(
            id: 1,
            name: "bulbasaur",
            imageURL: nil,
            heightInMeters: 0.7,
            weightInKilograms: 6.9,
            baseExperience: 64,
            types: ["grass", "poison"],
            abilities: ["overgrow"],
            stats: [PokemonStat(name: "hp", value: 45)],
            weaknesses: ["fire"]
        )
    }

    private static func makeViewModel(id: Int, repository: PokemonRepository) -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            id: id,
            getPokemonDetail: GetPokemonDetailUseCase(repository: repository),
            getPokemonEvolutions: GetPokemonEvolutionsUseCase(repository: repository),
            toggleFavorite: ToggleFavoriteUseCase(repository: repository),
            isPokemonFavorite: IsPokemonFavoriteUseCase(repository: repository)
        )
    }
}
