import Foundation

@Observable
@MainActor
final class PokemonDetailViewModel {
    enum State: Equatable {
        case loading
        case loaded(PokemonDetail)
        case error(String)
    }

    private(set) var state: State = .loading

    private let id: Int
    private let getPokemonDetail: GetPokemonDetailUseCase

    init(id: Int, getPokemonDetail: GetPokemonDetailUseCase) {
        self.id = id
        self.getPokemonDetail = getPokemonDetail
    }

    func load() async {
        state = .loading
        do {
            let detail = try await getPokemonDetail(id: id)
            state = .loaded(detail)
        } catch let error as PokemonError {
            state = .error(message(for: error))
        } catch {
            state = .error("Ocurrió un error inesperado.")
        }
    }

    private func message(for error: PokemonError) -> String {
        switch error {
        case .notFound:
            return "No se encontró este Pokémon."
        case .connectivity:
            return "Revisa tu conexión a internet e intenta de nuevo."
        case .unknown:
            return "Algo salió mal. Intenta de nuevo."
        }
    }
}
