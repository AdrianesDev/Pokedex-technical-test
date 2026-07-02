import Foundation

/// Local persistence record. Doubles as both the offline cache for the
/// list screen and the favorites store — one shape, one source of truth,
/// instead of maintaining two overlapping schemas.
///
/// Backed by `UserDefaults` + `Codable` rather than SwiftData: on this
/// SDK, `ModelContext.fetch` crashes (EXC_BREAKPOINT) inside the SwiftData
/// framework itself on every call — reproducible with a bare
/// `FetchDescriptor`, no predicate, in-memory or on-disk, from a clean
/// call site with no preceding concurrency. Confirmed on both iOS 26.5 and
/// iOS 18.5, so it isn't a beta-specific issue. Given the dataset here is
/// at most a few dozen small records, `UserDefaults` is a simple, fully
/// reliable substitute — no schema, no migrations, no framework bug.
struct PokemonRecord: Codable, Sendable {
    let id: Int
    var name: String
    var imageURLString: String?
    var types: [String]
    var isFavorite: Bool
    var cachedAt: Date
}
