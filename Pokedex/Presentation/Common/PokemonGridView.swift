import SwiftUI

/// Shared by the list and favorites screens — same card grid, different
/// data source feeding it.
struct PokemonGridView: View {
    let pokemon: [Pokemon]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pokemon) { item in
                    NavigationLink(value: item.id) {
                        PokemonCardView(pokemon: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }
}
