import Testing
@testable import Pokedex

struct PokemonMapperTests {
    @Test func mapConvertsUnitsAndComputesWeaknesses() {
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [
                PokemonTypeSlotDTO(slot: 1, type: NamedResourceDTO(name: "grass", url: "")),
                PokemonTypeSlotDTO(slot: 2, type: NamedResourceDTO(name: "poison", url: ""))
            ],
            stats: [
                PokemonStatSlotDTO(baseStat: 45, effort: 0, stat: NamedResourceDTO(name: "hp", url: ""))
            ],
            abilities: [
                PokemonAbilitySlotDTO(isHidden: false, slot: 1, ability: NamedResourceDTO(name: "overgrow", url: ""))
            ],
            sprites: PokemonSpritesDTO(other: nil)
        )

        let detail = PokemonMapper.map(dto)

        #expect(detail.heightInMeters == 0.7)
        #expect(detail.weightInKilograms == 6.9)
        #expect(detail.types == ["grass", "poison"])
        #expect(detail.abilities == ["overgrow"])
        #expect(detail.stats.first?.name == "hp" && detail.stats.first?.value == 45)
        #expect(detail.weaknesses.contains("fire"))
        // no sprite in the DTO -> falls back to the id-based artwork URL
        #expect(detail.imageURL?.absoluteString.hasSuffix("/1.png") == true)
    }

    @Test func mapSummaryOrdersTypesBySlotRegardlessOfInputOrder() {
        let dto = PokemonDetailDTO(
            id: 6,
            name: "charizard",
            height: 17,
            weight: 905,
            baseExperience: 267,
            types: [
                PokemonTypeSlotDTO(slot: 2, type: NamedResourceDTO(name: "flying", url: "")),
                PokemonTypeSlotDTO(slot: 1, type: NamedResourceDTO(name: "fire", url: ""))
            ],
            stats: [],
            abilities: [],
            sprites: PokemonSpritesDTO(other: nil)
        )

        let pokemon = PokemonMapper.mapSummary(dto)

        #expect(pokemon.types == ["fire", "flying"])
    }
}
