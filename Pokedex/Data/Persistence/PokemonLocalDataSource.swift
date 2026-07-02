import Foundation

/// UserDefaults-backed store (see `PokemonRecord` for why SwiftData was
/// dropped). Not actor-isolated — `UserDefaults` is thread-safe on its own,
/// so unlike the previous SwiftData-based version this doesn't need to be
/// pinned to `@MainActor`.
final class PokemonLocalDataSource: Sendable {
    private let defaults: UserDefaults
    private let storageKey = "com.pokedex.cachedPokemon"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func cacheList(_ pokemon: [Pokemon]) {
        var records = allRecords()
        for item in pokemon {
            if let index = records.firstIndex(where: { $0.id == item.id }) {
                records[index].name = item.name
                records[index].imageURLString = item.imageURL?.absoluteString
                records[index].types = item.types
                records[index].cachedAt = .now
            } else {
                records.append(
                    PokemonRecord(
                        id: item.id,
                        name: item.name,
                        imageURLString: item.imageURL?.absoluteString,
                        types: item.types,
                        isFavorite: false,
                        cachedAt: .now
                    )
                )
            }
        }
        save(records)
    }

    func fetchCachedList() -> [Pokemon] {
        allRecords().sorted { $0.id < $1.id }.map(PokemonMapper.map)
    }

    /// Flips the favorite flag, creating the cache entry first if this
    /// Pokémon was favorited straight from Detail without ever going
    /// through the list (so it isn't cached yet). Returns the new state.
    @discardableResult
    func toggleFavorite(for pokemon: Pokemon) -> Bool {
        var records = allRecords()
        if let index = records.firstIndex(where: { $0.id == pokemon.id }) {
            records[index].isFavorite.toggle()
            let newState = records[index].isFavorite
            save(records)
            return newState
        } else {
            records.append(
                PokemonRecord(
                    id: pokemon.id,
                    name: pokemon.name,
                    imageURLString: pokemon.imageURL?.absoluteString,
                    types: pokemon.types,
                    isFavorite: true,
                    cachedAt: .now
                )
            )
            save(records)
            return true
        }
    }

    func isFavorite(id: Int) -> Bool {
        allRecords().first { $0.id == id }?.isFavorite ?? false
    }

    func fetchFavorites() -> [Pokemon] {
        allRecords().filter(\.isFavorite).sorted { $0.id < $1.id }.map(PokemonMapper.map)
    }

    private func allRecords() -> [PokemonRecord] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([PokemonRecord].self, from: data)) ?? []
    }

    private func save(_ records: [PokemonRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
