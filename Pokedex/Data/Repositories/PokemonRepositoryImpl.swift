struct PokemonRepositoryImpl: PokemonRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchList(limit: Int, offset: Int) async throws -> [Pokemon] {
        do {
            let response: PokemonListResponseDTO = try await apiClient.request(
                PokemonEndpoint.list(limit: limit, offset: offset)
            )
            let ids = response.results.compactMap(\.id)
            return try await fetchDetails(for: ids)
        } catch let error as NetworkError {
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
            let dto: PokemonDetailDTO = try await apiClient.request(
                PokemonEndpoint.detail(id: id)
            )
            return PokemonMapper.map(dto)
        } catch let error as NetworkError {
            throw Self.map(error)
        }
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
