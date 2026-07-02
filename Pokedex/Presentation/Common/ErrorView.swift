import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(._58393C)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(message)
                .multilineTextAlignment(.center)
            Button("Reintentar", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(message: "Revisa tu conexión a internet.") {}
}
