import Foundation

struct Pokemon: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let imageURL: URL?
}
