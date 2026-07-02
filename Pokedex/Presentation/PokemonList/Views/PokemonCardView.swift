import SwiftUI

struct PokemonCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let pokemon: Pokemon

    @MainActor
    private var accentColor: Color {
        pokemon.types.first.map(PokemonTypeColor.color(for:)) ?? .gray
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()
                ZStack {
                    Image(colorScheme == .light ? .pokeballRed : .pokeball)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(0.1)

                    AsyncImage(url: pokemon.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit()
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 60, height: 60)
                }
            }
            VStack(alignment: .leading) {
                
                    Text(pokemon.name.capitalized)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(pokemon.types, id: \.self) { type in
                        TypeTagView(type: type)
                    }
                }
                // Reserves room for the max of 2 types a Pokémon can have,
                // so 1-type and 2-type cards render at the same height.
                .frame(height: 56, alignment: .top)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(accentColor.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(pokemon.name.capitalized), tipo \(pokemon.types.joined(separator: ", "))")
    }
}

#Preview {
    PokemonCardView(
        pokemon: Pokemon(
            id: 1,
            name: "bulbasaur",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"),
            types: ["grass", "poison"]
        )
    )
    .padding()
}
