import Testing
@testable import Pokedex

struct TypeEffectivenessTests {
    @Test func singleTypeWeaknesses() {
        let weaknesses = TypeEffectiveness.weaknesses(for: ["fire"])
        #expect(weaknesses == ["ground", "rock", "water"])
    }

    @Test func dualTypeWeaknessesAreUnioned() {
        // grass -> fire, ice, poison, flying, bug
        // poison -> ground, psychic
        let weaknesses = TypeEffectiveness.weaknesses(for: ["grass", "poison"])
        #expect(weaknesses == ["bug", "fire", "flying", "ground", "ice", "poison", "psychic"])
    }

    @Test func unknownTypeReturnsEmpty() {
        let weaknesses = TypeEffectiveness.weaknesses(for: ["not-a-real-type"])
        #expect(weaknesses.isEmpty)
    }
}
