import SwiftUI

struct PokemonDetailScreen: View {
    @State private var viewModel: PokemonDetailViewModel

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                        .onTapGesture {
                            Task { await viewModel.toggleFavorite() }
                        }
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .animation(.bouncy, value: viewModel.isFavorite)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.load() }
    }

    private var title: String {
        if case .loaded(let detail) = viewModel.state {
            return detail.name.capitalized
        }
        return ""
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.load() }
            }
        case .loaded(let detail):
            PokemonDetailContentView(detail: detail, evolutionsState: viewModel.evolutionsState)
        }
    }
}

#Preview {
    let repository = PreviewPokemonRepository()
    return NavigationStack {
        PokemonDetailScreen(
            viewModel: PokemonDetailViewModel(
                id: 25,
                getPokemonDetail: GetPokemonDetailUseCase(repository: repository),
                getPokemonEvolutions: GetPokemonEvolutionsUseCase(repository: repository),
                toggleFavorite: ToggleFavoriteUseCase(repository: repository),
                isPokemonFavorite: IsPokemonFavoriteUseCase(repository: repository)
            )
        )
    }
}
