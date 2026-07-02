extension PokemonGender {
    var displayText: String {
        switch self {
        case .genderless:
            return "Sin género"
        case .maleOnly:
            return "♂ Macho"
        case .femaleOnly:
            return "♀ Hembra"
        case .both:
            return "♂ ♀"
        }
    }
}
