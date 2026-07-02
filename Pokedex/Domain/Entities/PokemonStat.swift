struct PokemonStat: Identifiable, Equatable, Sendable {
    let name: String
    let value: Int

    var id: String { name }
}
