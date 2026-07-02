import Foundation

struct PokemonListResponseDTO: Decodable, Sendable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItemDTO]
}

struct PokemonListItemDTO: Decodable, Sendable {
    let name: String
    let url: String

    /// PokeAPI list responses don't include an id, only a self-referencing URL
    /// shaped like ".../pokemon/{id}/" — extract it here so the mapper doesn't
    /// need to know about that URL shape.
    var id: Int? {
        url.split(separator: "/").last.flatMap { Int($0) }
    }
}
