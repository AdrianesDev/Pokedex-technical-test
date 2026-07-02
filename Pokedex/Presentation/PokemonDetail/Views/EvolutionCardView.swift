import SwiftUI

struct EvolutionCardView: View {
    let evolution: PokemonEvolution

    private var numberText: String {
        String(format: "#%03d", evolution.id)
    }

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: evolution.imageURL) { phase in
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
            .frame(width: 72, height: 72)
            
            Text(numberText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            Text(evolution.name.capitalized)
                .font(.caption)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(8)
        .frame(width: 92)
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    EvolutionCardView(
        evolution: PokemonEvolution(
            id: 1,
            name: "bulbasaur",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        )
    )
    .padding()
}
