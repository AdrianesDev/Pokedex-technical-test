import Foundation
import Observation

@Observable
@MainActor
final class PokemonListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    private(set) var state: State = .idle
    private(set) var pokemon: [Pokemon] = []
    var searchText: String = ""

    private let getPokemonList: GetPokemonListUseCase

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
    }

    var filteredPokemon: [Pokemon] {
        guard !searchText.isEmpty else { return pokemon }
        return pokemon.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func loadInitial() async {
        guard pokemon.isEmpty else { return }
        state = .loading
        do {
            let result = try await getPokemonList(limit: 20, offset: 0)
            pokemon = result
            state = result.isEmpty ? .empty : .loaded
        } catch let error as PokemonError {
            state = .error(message(for: error))
        } catch {
            state = .error("Ocurrió un error inesperado.")
        }
    }

    private func message(for error: PokemonError) -> String {
        switch error {
        case .notFound:
            return "No se encontraron Pokémon."
        case .connectivity:
            return "Revisa tu conexión a internet e intenta de nuevo."
        case .unknown:
            return "Algo salió mal. Intenta de nuevo."
        }
    }
}
