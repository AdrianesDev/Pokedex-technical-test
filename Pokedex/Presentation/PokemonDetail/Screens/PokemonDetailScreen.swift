import SwiftUI

struct PokemonDetailScreen: View {
    @State private var viewModel: PokemonDetailViewModel
    @State private var isSaved: Bool = false

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: isSaved == true ? "bookmark.fill" : "bookmark")
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                isSaved.toggle()
                            }
                        }
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            })
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
            PokemonDetailContentView(detail: detail)
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailScreen(
            viewModel: PokemonDetailViewModel(
                id: 25,
                getPokemonDetail: GetPokemonDetailUseCase(repository: PreviewPokemonRepository())
            )
        )
    }
}
