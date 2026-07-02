import Foundation
import Observation

@Observable
@MainActor
final class PokemonDetailViewModel {
    enum State: Equatable {
        case loading
        case loaded(PokemonDetail)
        case error(String)
    }

    enum EvolutionsState: Equatable {
        case loading
        case loaded([PokemonEvolution])
        case failed
    }

    private(set) var state: State = .loading
    private(set) var evolutionsState: EvolutionsState = .loading
    private(set) var isFavorite = false

    private let id: Int
    private let getPokemonDetail: GetPokemonDetailUseCase
    private let getPokemonEvolutions: GetPokemonEvolutionsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let isPokemonFavorite: IsPokemonFavoriteUseCase

    init(
        id: Int,
        getPokemonDetail: GetPokemonDetailUseCase,
        getPokemonEvolutions: GetPokemonEvolutionsUseCase,
        toggleFavorite: ToggleFavoriteUseCase,
        isPokemonFavorite: IsPokemonFavoriteUseCase
    ) {
        self.id = id
        self.getPokemonDetail = getPokemonDetail
        self.getPokemonEvolutions = getPokemonEvolutions
        self.toggleFavoriteUseCase = toggleFavorite
        self.isPokemonFavorite = isPokemonFavorite
    }

    /// Runs both requests concurrently, but each updates its own published
    /// state independently — the name/stats appear the moment the (single,
    /// fast) detail call resolves, without waiting for the slower
    /// evolutions chain.
    func load() async {
        async let detail: Void = loadDetail()
        async let evolutions: Void = loadEvolutions()
        async let favorite: Void = loadFavoriteStatus()
        _ = await (detail, evolutions, favorite)
    }

    private func loadFavoriteStatus() async {
        isFavorite = await isPokemonFavorite(id: id)
    }

    func toggleFavorite() async {
        guard case .loaded(let detail) = state else { return }
        let pokemon = Pokemon(id: detail.id, name: detail.name, imageURL: detail.imageURL, types: detail.types)
        isFavorite = await toggleFavoriteUseCase(pokemon)
    }

    private func loadDetail() async {
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

    private func loadEvolutions() async {
        evolutionsState = .loading
        do {
            let evolutions = try await getPokemonEvolutions(id: id)
            evolutionsState = .loaded(evolutions)
        } catch {
            evolutionsState = .failed
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
