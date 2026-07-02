import Foundation

enum PokemonMapper {
    private static let artworkBaseURL =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork"

    static func mapSummary(_ dto: PokemonDetailDTO) -> Pokemon {
        Pokemon(
            id: dto.id,
            name: dto.name,
            imageURL: imageURL(for: dto),
            types: dto.types.sorted { $0.slot < $1.slot }.map { $0.type.name }
        )
    }

    static func map(_ dto: PokemonDetailDTO) -> PokemonDetail {
        let types = dto.types.sorted { $0.slot < $1.slot }.map { $0.type.name }

        return PokemonDetail(
            id: dto.id,
            name: dto.name,
            imageURL: imageURL(for: dto),
            heightInMeters: Double(dto.height) / 10.0,
            weightInKilograms: Double(dto.weight) / 10.0,
            baseExperience: dto.baseExperience,
            types: types,
            abilities: dto.abilities.sorted { $0.slot < $1.slot }.map { $0.ability.name },
            stats: dto.stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) },
            weaknesses: TypeEffectiveness.weaknesses(for: types)
        )
    }

    static func mapEvolutions(_ chain: EvolutionChainDTO) -> [PokemonEvolution] {
        flattenEvolutions(chain.chain)
    }

    static func map(_ record: PokemonRecord) -> Pokemon {
        Pokemon(
            id: record.id,
            name: record.name,
            imageURL: record.imageURLString.flatMap(URL.init(string:)),
            types: record.types
        )
    }

    /// Walks the evolution tree depth-first, listing every stage (including
    /// branching families like Eevee) in the order PokeAPI returns them.
    @MainActor
    private static func flattenEvolutions(_ link: EvolutionChainLinkDTO) -> [PokemonEvolution] {
        let id = speciesId(from: link.species.url)
        let current = PokemonEvolution(
            id: id ?? 0,
            name: link.species.name,
            imageURL: id.flatMap(artworkURL)
        )
        return [current] + link.evolvesTo.flatMap(flattenEvolutions)
    }

    private static func speciesId(from url: String) -> Int? {
        url.split(separator: "/").last.flatMap { Int($0) }
    }

    private static func imageURL(for dto: PokemonDetailDTO) -> URL? {
        dto.sprites.other?.officialArtwork?.frontDefault
            .flatMap(URL.init(string:)) ?? artworkURL(for: dto.id)
    }

    /// PokeAPI sprite paths are predictable from the id — used as a fallback
    /// when a detail response unexpectedly omits official artwork, and for
    /// evolution stages (whose species payload has no sprite field at all).
    private static func artworkURL(for id: Int) -> URL? {
        URL(string: "\(artworkBaseURL)/\(id).png")
    }
}
