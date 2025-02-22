import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}
