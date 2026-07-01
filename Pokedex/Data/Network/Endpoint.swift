import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

enum PokemonEndpoint: Endpoint {
    case list(limit: Int, offset: Int)
    case detail(id: Int)

    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let id):
            return "/pokemon/\(id)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        case .detail:
            return nil
        }
    }
}
