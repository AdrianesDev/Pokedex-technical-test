import Foundation

/// Fake `PokemonRepository` that returns static data instantly, with no
/// network calls — used by SwiftUI Previews (and reusable later for
/// PokemonListViewModel unit tests) so they don't depend on connectivity.
struct PreviewPokemonRepository: PokemonRepository {
    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon] {
        [
            Pokemon(id: 1, name: "bulbasaur", imageURL: artworkURL(1), types: ["grass", "poison"]),
            Pokemon(id: 4, name: "charmander", imageURL: artworkURL(4), types: ["fire"]),
            Pokemon(id: 7, name: "squirtle", imageURL: artworkURL(7), types: ["water"]),
            Pokemon(id: 25, name: "pikachu", imageURL: artworkURL(25), types: ["electric"])
        ]
    }

    func fetchDetail(id: Int) async throws -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: "pikachu",
            imageURL: artworkURL(id),
            heightInMeters: 0.4,
            weightInKilograms: 6.0,
            baseExperience: 112,
            types: ["electric"],
            abilities: ["static", "lightning-rod"],
            stats: [
                PokemonStat(name: "hp", value: 35),
                PokemonStat(name: "attack", value: 55)
            ]
        )
    }

    private func artworkURL(_ id: Int) -> URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}
