import SwiftUI

struct FavoritesScreen: View {
    @State private var viewModel: FavoritesViewModel
    private let dependencies: AppDependencies

    init(viewModel: FavoritesViewModel, dependencies: AppDependencies) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Favoritos")
                .onAppear {
                    Task { await viewModel.reload() }
                }
                .navigationDestination(for: Int.self) { pokemonId in
                    PokemonDetailScreen(viewModel: dependencies.makeDetailViewModel(id: pokemonId))
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if !viewModel.hasLoaded {
            LoadingView()
        } else if viewModel.favorites.isEmpty {
            EmptyStateView(message: "Aún no tienes Pokémon favoritos.\nToca el marcador en un Pokémon para guardarlo.")
        } else {
            PokemonGridView(pokemon: viewModel.favorites)
        }
    }
}

#Preview {
    let dependencies = AppDependencies(repository: PreviewPokemonRepository())
    return FavoritesScreen(viewModel: dependencies.makeFavoritesViewModel(), dependencies: dependencies)
}
