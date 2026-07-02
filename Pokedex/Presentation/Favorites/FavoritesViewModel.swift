import Foundation
import Observation

@Observable
@MainActor
final class FavoritesViewModel {
    private(set) var favorites: [Pokemon] = []
    private(set) var hasLoaded = false

    private let getFavoritePokemon: GetFavoritePokemonUseCase

    init(getFavoritePokemon: GetFavoritePokemonUseCase) {
        self.getFavoritePokemon = getFavoritePokemon
    }

    /// Called from `.onAppear` (not `.task`) — favorites change from the
    /// Detail screen, and a TabView keeps this screen alive across tab
    /// switches, so it needs to re-fetch every time it becomes visible
    /// again, not just once.
    func reload() async {
        favorites = await getFavoritePokemon()
        hasLoaded = true
    }
}
