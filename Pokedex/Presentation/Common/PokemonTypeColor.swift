import SwiftUI

enum PokemonTypeColor {
    private static let colors: [String: Color] = [
        "normal": Color(.normal),
        "fire": Color(.fire),
        "water": Color(.water),
        "electric": Color(.electric),
        "grass": Color(.grass),
        "ice": Color(.ice),
        "fighting": Color(.fighting),
        "poison": Color(.poison),
        "ground": Color(.ground),
        "flying": Color(.flying),
        "psychic": Color(.psychic),
        "bug": Color(.bug),
        "rock": Color(.rock),
        "ghost": Color(.ghost),
        "dragon": Color(.dragon),
        "dark": Color(.dark),
        "steel": Color(.steel),
        "fairy": Color(.fairy)
    ]

    static func color(for type: String) -> Color {
        colors[type.lowercased()] ?? .gray
    }
}
