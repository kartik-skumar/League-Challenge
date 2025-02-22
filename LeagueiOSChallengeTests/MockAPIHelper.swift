import Foundation
import LeagueiOSChallenge

class MockAPIHelper: APIServiceProtocol {
    var shouldReturnError = false
    var mockData: Data?

    func performRequest<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        guard let data = mockData else {
            throw URLError(.badServerResponse)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to decode mock data")
            throw error
        }
    }
}
