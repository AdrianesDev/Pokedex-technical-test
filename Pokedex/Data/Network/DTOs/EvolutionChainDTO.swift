import Foundation

struct EvolutionChainDTO: Decodable, Sendable {
    let chain: EvolutionChainLinkDTO
}

/// Recursive on purpose — mirrors how PokeAPI nests each evolution stage
/// inside the previous one's `evolves_to`.
struct EvolutionChainLinkDTO: Decodable, Sendable {
    let species: NamedResourceDTO
    let evolvesTo: [EvolutionChainLinkDTO]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
