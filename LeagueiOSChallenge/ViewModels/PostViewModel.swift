import Foundation

class PostViewModel: ObservableObject {
    @Published private(set) var posts: [Post] = []
    @Published private(set) var errorMessage: String?
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    @MainActor
    func fetchPosts(userId: Int) async {
        do {
            let endpoint: APIEndpoint = .postsFromUser(userId: userId)
            let fetchedPosts: [Post] = try await apiService.performRequest(
                endpoint: endpoint, responseType: [Post].self
            )
            self.posts = fetchedPosts
        } catch {
            self.errorMessage = "Failed to fetch posts. Please try again."
        }
    }
}
