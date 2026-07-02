import SwiftUI

struct PokemonDetailContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    let detail: PokemonDetail
    let evolutionsState: PokemonDetailViewModel.EvolutionsState

    @MainActor
    private var accentColor: Color {
        detail.types.first.map(PokemonTypeColor.color(for:)) ?? .gray
    }

    private var numberText: String {
        String(format: "#%03d", detail.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    Image(colorScheme == .light ? .pokeballRed : .pokeball)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .opacity(0.2)

                    VStack {
                        AsyncImage(url: detail.imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFit()
                            case .failure:
                                Image(.pokeballEmpty)
                                    .resizable()
                                    .scaledToFit()
                            default:
                                ProgressView()
                            }
                        }
                        .frame(width: 180, height: 180)

                        HStack(spacing: 8) {
                            ForEach(detail.types, id: \.self) { type in
                                TypeTagView(type: type)
                            }
                        }

                        HStack(spacing: 24) {
                            metric(title: "Altura", value: String(format: "%.1f m", detail.heightInMeters))
                            metric(title: "Peso", value: String(format: "%.1f kg", detail.weightInKilograms))
                            if let baseExperience = detail.baseExperience {
                                metric(title: "Exp. base", value: "\(baseExperience)")
                            }
                        }
                    }
                }
                
                section(title: "No. de pokémon") {
                    Text(numberText)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                }
                
                section(title: "Habilidades") {
                    Text(detail.abilities.map { $0.capitalized }.joined(separator: ", "))
                        .foregroundStyle(.secondary)
                }

                if !detail.weaknesses.isEmpty {
                    section(title: "Debilidades") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                            ForEach(detail.weaknesses, id: \.self) { type in
                                TypeTagView(type: type)
                            }
                        }
                    }
                }

                section(title: "Estadísticas") {
                    VStack(spacing: 10) {
                        ForEach(detail.stats) { stat in
                            StatRowView(stat: stat, accentColor: accentColor)
                        }
                    }
                }

                evolutionsSection
            }
            .padding()
        }
        .background(accentColor.opacity(0.4))
    }

    @ViewBuilder
    private var evolutionsSection: some View {
        switch evolutionsState {
        case .loading:
            section(title: "Evoluciones") {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        case .failed:
            EmptyView()
        case .loaded(let evolutions):
            if !evolutions.isEmpty {
                section(title: "Evoluciones") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(evolutions) { evolution in
                                EvolutionCardView(evolution: evolution)
                            }
                        }
                    }
                }
            }
        }
    }

    private func metric(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PokemonDetailContentView(
        detail: PokemonDetail(
            id: 1,
            name: "bulbasaur",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"),
            heightInMeters: 0.7,
            weightInKilograms: 6.9,
            baseExperience: 64,
            types: ["grass", "poison"],
            abilities: ["overgrow", "chlorophyll"],
            stats: [
                PokemonStat(name: "hp", value: 45),
                PokemonStat(name: "attack", value: 49),
                PokemonStat(name: "defense", value: 49)
            ],
            weaknesses: ["fire", "ice", "flying", "psychic"]
        ),
        evolutionsState: .loaded([
            PokemonEvolution(id: 1, name: "bulbasaur", imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")),
            PokemonEvolution(id: 2, name: "ivysaur", imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png")),
            PokemonEvolution(id: 3, name: "venusaur", imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"))
        ])
    )
}
