import Foundation

struct PokemonSpeciesDTO: Decodable, Sendable {
    let evolutionChain: EvolutionChainReferenceDTO

    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }

    /// The species response only links the evolution chain by URL
    /// (".../evolution-chain/{id}/"), same shape as the list endpoint's
    /// pokemon URLs — extracted the same way.
    var evolutionChainId: Int? {
        evolutionChain.url.split(separator: "/").last.flatMap { Int($0) }
    }
}

struct EvolutionChainReferenceDTO: Decodable, Sendable {
    let url: String
}
