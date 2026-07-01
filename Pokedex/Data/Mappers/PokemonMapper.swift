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
        PokemonDetail(
            id: dto.id,
            name: dto.name,
            imageURL: imageURL(for: dto),
            heightInMeters: Double(dto.height) / 10.0,
            weightInKilograms: Double(dto.weight) / 10.0,
            baseExperience: dto.baseExperience,
            types: dto.types.sorted { $0.slot < $1.slot }.map { $0.type.name },
            abilities: dto.abilities.sorted { $0.slot < $1.slot }.map { $0.ability.name },
            stats: dto.stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) }
        )
    }

    private static func imageURL(for dto: PokemonDetailDTO) -> URL? {
        dto.sprites.other?.officialArtwork?.frontDefault
            .flatMap(URL.init(string:)) ?? artworkURL(for: dto.id)
    }

    /// PokeAPI sprite paths are predictable from the id — used as a fallback
    /// when a detail response unexpectedly omits official artwork.
    private static func artworkURL(for id: Int) -> URL? {
        URL(string: "\(artworkBaseURL)/\(id).png")
    }
}
