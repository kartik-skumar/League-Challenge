import Foundation

struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

