import Foundation

struct PokemonDetail: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let imageURL: URL?
    let heightInMeters: Double
    let weightInKilograms: Double
    let baseExperience: Int?
    let types: [String]
    let abilities: [String]
    let stats: [PokemonStat]
    let weaknesses: [String]
}
