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
    private(set) var selectedType: String?

    private let getPokemonList: GetPokemonListUseCase

    init(getPokemonList: GetPokemonListUseCase) {
        self.getPokemonList = getPokemonList
    }

    /// Only the types actually present in the loaded list — filtering by a
    /// type nothing here has would just be a dead end for the user.
    var availableTypes: [String] {
        Array(Set(pokemon.flatMap(\.types))).sorted()
    }

    var filteredPokemon: [Pokemon] {
        var result = pokemon
        if let selectedType {
            result = result.filter { $0.types.contains(selectedType) }
        }
        guard !searchText.isEmpty else { return result }
        return result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    /// `nil` means "Todos" — always clears the filter directly. A concrete
    /// type toggles: tapping the already-selected chip clears it too.
    func selectType(_ type: String?) {
        guard let type else {
            selectedType = nil
            return
        }
        selectedType = (selectedType == type) ? nil : type
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
