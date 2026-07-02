import SwiftUI

struct EmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme
    var message: String = "No hay Pokémon disponibles."

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(colorScheme == .light ? .pokeballRed : .pokeball)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Image(systemName: "nosign")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        colorScheme == .light ? .black.opacity(0.4) : .gray
                            )
            }
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
