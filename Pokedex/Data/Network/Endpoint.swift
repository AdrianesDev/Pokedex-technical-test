import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

enum PokemonEndpoint: Endpoint {
    case list(limit: Int, offset: Int)
    case detail(id: Int)
    case species(id: Int)
    case evolutionChain(id: Int)

    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let id):
            return "/pokemon/\(id)"
        case .species(let id):
            return "/pokemon-species/\(id)"
        case .evolutionChain(let id):
            return "/evolution-chain/\(id)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        case .detail, .species, .evolutionChain:
            return nil
        }
    }
}
