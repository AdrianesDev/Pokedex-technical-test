import Foundation

struct PokemonDetailDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let types: [PokemonTypeSlotDTO]
    let stats: [PokemonStatSlotDTO]
    let abilities: [PokemonAbilitySlotDTO]
    let sprites: PokemonSpritesDTO

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, stats, abilities, sprites
        case baseExperience = "base_experience"
    }
}

struct PokemonTypeSlotDTO: Decodable, Sendable {
    let slot: Int
    let type: NamedResourceDTO
}

struct PokemonStatSlotDTO: Decodable, Sendable {
    let baseStat: Int
    let effort: Int
    let stat: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct PokemonAbilitySlotDTO: Decodable, Sendable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedResourceDTO

    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}

struct NamedResourceDTO: Decodable, Sendable {
    let name: String
    let url: String
}

struct PokemonSpritesDTO: Decodable, Sendable {
    let other: OtherSpritesDTO?

    struct OtherSpritesDTO: Decodable, Sendable {
        let officialArtwork: OfficialArtworkDTO?

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }

    struct OfficialArtworkDTO: Decodable, Sendable {
        let frontDefault: String?

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
