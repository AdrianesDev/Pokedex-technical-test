import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noConnection
    case serverError(statusCode: Int)
    case decodingFailed
    case unknown
}
