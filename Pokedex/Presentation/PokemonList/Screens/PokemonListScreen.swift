import SwiftUI

struct PokemonListScreen: View {
    @State private var viewModel: PokemonListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(viewModel: PokemonListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokédex")
                .searchable(text: $viewModel.searchText, prompt: "Buscar Pokémon")
                .task { await viewModel.loadInitial() }
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
            if viewModel.filteredPokemon.isEmpty {
                EmptyStateView(message: "Sin resultados para \"\(viewModel.searchText)\"")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct PokemonListScreen_container: View {
    @State private var viewModel: PokemonListViewModel = PokemonListViewModel(
        getPokemonList: GetPokemonListUseCase(repository: PreviewPokemonRepository())
    )
    var body: some View {
        PokemonListScreen(viewModel: viewModel)
    }
}

#Preview {
    PokemonListScreen_container()
}
