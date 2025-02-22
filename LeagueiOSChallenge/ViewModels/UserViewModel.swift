import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIHelper.shared) {
        self.apiService = apiService
    }

    @MainActor
    func fetchUsers() async {
        do {
            let fetchedUsers: [User] = try await apiService.performRequest(
                endpoint: .users, responseType: [User].self
            )
            users = fetchedUsers
        } catch {
            self.errorMessage = "Failed to fetch user details."
        }
    }
    
    func isValidEmailDomain(_ email: String) -> Bool {
        let allowedDomains = [".com", ".net", ".biz"]
        return allowedDomains.contains { email.hasSuffix($0) }
    }
}
