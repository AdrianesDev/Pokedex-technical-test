import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Cargando Pokémon...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
