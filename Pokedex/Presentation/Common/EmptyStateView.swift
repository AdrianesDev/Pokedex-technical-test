import SwiftUI

struct EmptyStateView: View {
    var message: String = "No hay Pokémon disponibles."

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(.pokeballRed)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Image(systemName: "nosign")
                    .font(.system(size: 60))
                    .foregroundStyle(.black.opacity(0.4))
            }
            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
