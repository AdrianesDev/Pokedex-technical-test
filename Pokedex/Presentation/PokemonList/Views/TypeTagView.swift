import SwiftUI

struct TypeTagView: View {
    let type: String

    var body: some View {
        Text(type.capitalized)
            .font(.caption.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 70)
            .padding(.vertical, 6)
            .background(PokemonTypeColor.color(for: type))
            .foregroundStyle(.white)
            .shadow(radius: 10)
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        TypeTagView(type: "grass")
        TypeTagView(type: "poison")
    }
}
