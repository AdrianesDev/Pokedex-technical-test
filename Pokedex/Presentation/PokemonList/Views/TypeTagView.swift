import SwiftUI

struct TypeTagView: View {
    let type: String

    var body: some View {
        Text(type.capitalized)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(PokemonTypeColor.color(for: type))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        TypeTagView(type: "grass")
        TypeTagView(type: "poison")
    }
}
