import XCTest
@testable import LeagueiOSChallenge

final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockAPI: MockAPIHelper!

    override func setUp() async throws {
        try await super.setUp()
        mockAPI = MockAPIHelper()
        viewModel = AuthViewModel(apiService: mockAPI)
    }

    override func tearDown() async throws {
        viewModel = nil
        mockAPI = nil
        try await super.tearDown()
    }

    func testLoginSuccess() async {
        let expectation = expectation(description: "Login should succeed")
        let mockLoginResponse = LoginResponse(apiKey: "16DF97F2420139E8AC73AC8F016072B3")
        mockAPI.mockData = try! JSONEncoder().encode(mockLoginResponse)
        await viewModel.login(username: "wronguser", password: "wrongpass")
        XCTAssertEqual(KeychainHelper.shared.read(key: "apiKey"), "16DF97F2420139E8AC73AC8F016072B3")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }
    
    func testContinueAsGuest() async {
        let expectation = expectation(description: "Guest login should succeed")
        
        let mockLoginResponse = LoginResponse(apiKey: "16DF97F2420139E8AC73AC8F016072B3")
        mockAPI.mockData = try! JSONEncoder().encode(mockLoginResponse)
        await viewModel.continueAsGuest()
        XCTAssertEqual(KeychainHelper.shared.read(key: "apiKey"), "16DF97F2420139E8AC73AC8F016072B3")
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertTrue(viewModel.isGuestUser)
        XCTAssertNil(viewModel.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }

    func testLoginFailure() async {
        let expectation = expectation(description: "Login should fail")
        mockAPI.shouldReturnError = true
        await viewModel.login(username: "", password: "")
        XCTAssertNil(KeychainHelper.shared.read(key: "invalid"))
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }

    func testLogout() {
        viewModel.logout()
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(KeychainHelper.shared.read(key: "apiKey"))
    }
}
