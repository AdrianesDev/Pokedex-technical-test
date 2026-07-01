import SwiftUI

enum PokemonTypeColor {
    private static let colors: [String: Color] = [
        "normal": Color(red: 0.66, green: 0.66, blue: 0.47),
        "fire": Color(red: 0.94, green: 0.50, blue: 0.19),
        "water": Color(red: 0.41, green: 0.56, blue: 0.94),
        "electric": Color(red: 0.97, green: 0.82, blue: 0.19),
        "grass": Color(red: 0.47, green: 0.78, blue: 0.31),
        "ice": Color(red: 0.60, green: 0.85, blue: 0.85),
        "fighting": Color(red: 0.75, green: 0.19, blue: 0.16),
        "poison": Color(red: 0.63, green: 0.25, blue: 0.63),
        "ground": Color(red: 0.88, green: 0.75, blue: 0.41),
        "flying": Color(red: 0.66, green: 0.56, blue: 0.94),
        "psychic": Color(red: 0.97, green: 0.35, blue: 0.53),
        "bug": Color(red: 0.66, green: 0.72, blue: 0.13),
        "rock": Color(red: 0.72, green: 0.63, blue: 0.22),
        "ghost": Color(red: 0.44, green: 0.35, blue: 0.60),
        "dragon": Color(red: 0.44, green: 0.22, blue: 0.97),
        "dark": Color(red: 0.44, green: 0.35, blue: 0.28),
        "steel": Color(red: 0.72, green: 0.72, blue: 0.82),
        "fairy": Color(red: 0.93, green: 0.60, blue: 0.67)
    ]

    static func color(for type: String) -> Color {
        colors[type.lowercased()] ?? .gray
    }
}
