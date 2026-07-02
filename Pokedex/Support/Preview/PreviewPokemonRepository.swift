import Foundation

/// Fake `PokemonRepository` that returns static data instantly, with no
/// network calls — used by SwiftUI Previews (and reusable later for
/// PokemonListViewModel unit tests) so they don't depend on connectivity.
struct PreviewPokemonRepository: PokemonRepository {
    /// Reference type so favorite toggles persist across calls even though
    /// the repository itself is a value type — previews/tests only, never
    /// touches real storage.
    private final class FavoritesBox: @unchecked Sendable {
        var ids: Set<Int> = []
    }

    private let favoritesBox = FavoritesBox()

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
            ],
            weaknesses: TypeEffectiveness.weaknesses(for: ["electric"])
        )
    }

    func fetchEvolutions(id: Int) async throws -> [PokemonEvolution] {
        [
            PokemonEvolution(id: 172, name: "pichu", imageURL: artworkURL(172)),
            PokemonEvolution(id: 25, name: "pikachu", imageURL: artworkURL(25)),
            PokemonEvolution(id: 26, name: "raichu", imageURL: artworkURL(26))
        ]
    }

    @discardableResult
    func toggleFavorite(_ pokemon: Pokemon) async -> Bool {
        if favoritesBox.ids.contains(pokemon.id) {
            favoritesBox.ids.remove(pokemon.id)
        } else {
            favoritesBox.ids.insert(pokemon.id)
        }
        return favoritesBox.ids.contains(pokemon.id)
    }

    func isFavorite(id: Int) async -> Bool {
        favoritesBox.ids.contains(id)
    }

    func fetchFavorites() async -> [Pokemon] {
        try! await fetchList(limit: 20, offset: 0).filter { favoritesBox.ids.contains($0.id) }
    }

    private func artworkURL(_ id: Int) -> URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}
