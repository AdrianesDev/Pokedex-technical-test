/// Static type effectiveness chart — pure Domain business logic, no
/// networking involved. `weaknesses(for:)` unions each type's individual
/// weaknesses; it deliberately ignores cross-type resistance/immunity
/// cancellation (e.g. a real Water/Ground Pokémon actually resists
/// Electric despite Water alone being weak to it). Computing the exact
/// dual-type multiplier would need 1-2 extra `/type/{name}` calls per
/// detail screen — this trade-off avoids that for a simpler, deterministic
/// result that's accurate for single-type Pokémon and "close enough" for
/// dual-type ones.
nonisolated enum TypeEffectiveness {
    private static let weaknessesByType: [String: Set<String>] = [
        "normal": ["fighting"],
        "fire": ["water", "ground", "rock"],
        "water": ["electric", "grass"],
        "electric": ["ground"],
        "grass": ["fire", "ice", "poison", "flying", "bug"],
        "ice": ["fire", "fighting", "rock", "steel"],
        "fighting": ["flying", "psychic", "fairy"],
        "poison": ["ground", "psychic"],
        "ground": ["water", "grass", "ice"],
        "flying": ["electric", "ice", "rock"],
        "psychic": ["bug", "ghost", "dark"],
        "bug": ["fire", "flying", "rock"],
        "rock": ["water", "grass", "fighting", "ground", "steel"],
        "ghost": ["ghost", "dark"],
        "dragon": ["ice", "dragon", "fairy"],
        "dark": ["fighting", "bug", "fairy"],
        "steel": ["fire", "fighting", "ground"],
        "fairy": ["poison", "steel"]
    ]

    static func weaknesses(for types: [String]) -> [String] {
        let combined = types.reduce(into: Set<String>()) { result, type in
            result.formUnion(weaknessesByType[type.lowercased()] ?? [])
        }
        return combined.sorted()
    }
}
