import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isGuestUser = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIHelper.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    private func fetchApiKey(username: String? = nil, password: String? = nil) async {
        isLoading = true
        do {
            let loginResponse: LoginResponse = try await apiService.performRequest(
                endpoint: .login(username: username, password: password), responseType: LoginResponse.self
            )
            
            KeychainHelper.shared.save(key: "apiKey", value: loginResponse.apiKey)
            isAuthenticated = true
            isLoading = false
        } catch {
            self.errorMessage = "Login failed. Please check your credentials."
            isLoading = false
        }
    }

    func login(username: String, password: String) async {
        await fetchApiKey(username: username, password: password)
    }
    
    func continueAsGuest() async {
        await fetchApiKey()
        isGuestUser = true
    }

    func logout() {
        KeychainHelper.shared.delete(key: "apiKey")
        isAuthenticated = false
    }
}
