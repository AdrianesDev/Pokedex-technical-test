import Foundation

struct EvolutionChainDTO: Decodable, Sendable {
    let chain: EvolutionChainLinkDTO
}

struct EvolutionChainLinkDTO: Decodable, Sendable {
    let species: NamedResourceDTO
    let evolvesTo: [EvolutionChainLinkDTO]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
