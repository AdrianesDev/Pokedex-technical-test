import Foundation

struct PokemonEvolution: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let imageURL: URL?
}
