import SwiftUI

struct PokemonListScreen: View {
    @State private var viewModel: PokemonListViewModel
    private let dependencies: AppDependencies

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(viewModel: PokemonListViewModel, dependencies: AppDependencies) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokédex")
                .searchable(text: $viewModel.searchText, prompt: "Buscar Pokémon")
                .task { await viewModel.loadInitial() }
                .navigationDestination(for: Int.self) { pokemonId in
                    PokemonDetailScreen(viewModel: dependencies.makeDetailViewModel(id: pokemonId))
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.loadInitial() }
            }
        case .empty:
            EmptyStateView()
        case .loaded:
            VStack(spacing: 12) {
                CategoryFilterBar(
                    types: viewModel.availableTypes,
                    selectedType: viewModel.selectedType,
                    onSelect: viewModel.selectType
                )

                if viewModel.filteredPokemon.isEmpty {
                    EmptyStateView(message: "Sin resultados para \"\(viewModel.searchText)\"")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.filteredPokemon) { pokemon in
                                NavigationLink(value: pokemon.id) {
                                    PokemonCardView(pokemon: pokemon)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
    }
}

struct PokemonListScreen_container: View {
    private let dependencies: AppDependencies
    @State private var viewModel: PokemonListViewModel

    init() {
        let dependencies = AppDependencies(repository: PreviewPokemonRepository())
        self.dependencies = dependencies
        _viewModel = State(initialValue: dependencies.makeListViewModel())
    }

    var body: some View {
        PokemonListScreen(viewModel: viewModel, dependencies: dependencies)
    }
}

#Preview {
    PokemonListScreen_container()
}
