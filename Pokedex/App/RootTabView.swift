import SwiftUI

struct RootTabView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            PokemonListScreen(
                viewModel: dependencies.makeListViewModel(),
                dependencies: dependencies
            )
            .tabItem {
                Label("Pokédex", systemImage: "list.bullet")
            }

            FavoritesScreen(
                viewModel: dependencies.makeFavoritesViewModel(),
                dependencies: dependencies
            )
            .tabItem {
                Label("Favoritos", systemImage: "bookmark.fill")
            }
        }
    }
}

#Preview {
    RootTabView(dependencies: AppDependencies(repository: PreviewPokemonRepository()))
}
