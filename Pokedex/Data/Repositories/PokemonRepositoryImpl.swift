struct PokemonRepositoryImpl: PokemonRepository {
    private let apiClient: APIClientProtocol
    private let localDataSource: PokemonLocalDataSource

    init(apiClient: APIClientProtocol = APIClient(), localDataSource: PokemonLocalDataSource) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon] {
        do {
            let response: PokemonListResponseDTO = try await apiClient.request(
                PokemonEndpoint.list(limit: limit, offset: offset)
            )
            let ids = response.results.compactMap(\.id)
            let pokemon = try await fetchDetails(for: ids)
            localDataSource.cacheList(pokemon)
            return pokemon
        } catch let error as NetworkError {
            if case .noConnection = error {
                let cached = localDataSource.fetchCachedList()
                if !cached.isEmpty { return cached }
            }
            throw Self.map(error)
        }
    }

    /// The list endpoint only returns name + url, no type/sprite data, so each
    /// row's card (name, image, type-colored tags) needs the detail payload.
    /// Fetched concurrently — sequential would mean 20 round trips in series.
    private func fetchDetails(for ids: [Int]) async throws -> [Pokemon] {
        try await withThrowingTaskGroup(of: (Int, Pokemon).self) { group in
            for (index, id) in ids.enumerated() {
                group.addTask {
                    let dto: PokemonDetailDTO = try await self.apiClient.request(
                        PokemonEndpoint.detail(id: id)
                    )
                    return (index, PokemonMapper.mapSummary(dto))
                }
            }

            var ordered = [Pokemon?](repeating: nil, count: ids.count)
            for try await (index, pokemon) in group {
                ordered[index] = pokemon
            }
            return ordered.compactMap { $0 }
        }
    }

    func fetchDetail(id: Int) async throws -> PokemonDetail {
        do {
            let dto: PokemonDetailDTO = try await apiClient.request(PokemonEndpoint.detail(id: id))
            return PokemonMapper.map(dto)
        } catch let error as NetworkError {
            throw Self.map(error)
        }
    }

    /// Evolutions need species (for the evolution-chain id) then the chain
    /// itself — 2 sequential calls on top of the detail's own request.
    /// Kept separate from `fetchDetail` so the name/stats/etc. render as
    /// soon as the single `/pokemon/{id}` call resolves, instead of the
    /// whole screen waiting on this slower chain.
    func fetchEvolutions(id: Int) async throws -> [PokemonEvolution] {
        do {
            let species: PokemonSpeciesDTO = try await apiClient.request(PokemonEndpoint.species(id: id))
            guard let chainId = species.evolutionChainId else { return [] }
            let chain: EvolutionChainDTO = try await apiClient.request(
                PokemonEndpoint.evolutionChain(id: chainId)
            )
            return PokemonMapper.mapEvolutions(chain)
        } catch let error as NetworkError {
            throw Self.map(error)
        }
    }

    @discardableResult
    func toggleFavorite(_ pokemon: Pokemon) async -> Bool {
        localDataSource.toggleFavorite(for: pokemon)
    }

    func isFavorite(id: Int) async -> Bool {
        localDataSource.isFavorite(id: id)
    }

    func fetchFavorites() async -> [Pokemon] {
        localDataSource.fetchFavorites()
    }

    private static func map(_ error: NetworkError) -> PokemonError {
        switch error {
        case .serverError(let statusCode) where statusCode == 404:
            return .notFound
        case .noConnection:
            return .connectivity
        case .invalidURL, .serverError, .decodingFailed, .unknown:
            return .unknown
        }
    }
}
