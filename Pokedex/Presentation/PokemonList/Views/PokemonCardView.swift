import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon

    private var accentColor: Color {
        pokemon.types.first.map(PokemonTypeColor.color(for:)) ?? .gray
    }

    var body: some View {
        HStack(spacing: 8) {
            VStack {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                VStack(spacing: 6) {
                    ForEach(pokemon.types, id: \.self) { type in
                        TypeTagView(type: type)
                    }
                }
            }
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
            .frame(width: 84, height: 84)

            
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(accentColor.opacity(0.25))
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
