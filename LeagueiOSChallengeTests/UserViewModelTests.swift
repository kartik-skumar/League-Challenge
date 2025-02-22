import XCTest
@testable import LeagueiOSChallenge

final class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockAPI: MockAPIHelper!

    override func setUp() async throws {
        try await super.setUp()
        mockAPI = MockAPIHelper()
        viewModel = UserViewModel(apiService: mockAPI)
    }

    override func tearDown() async throws {
        viewModel = nil
        mockAPI = nil
        try await super.tearDown()
    }

    func testFetchUsersSuccess() async {
        let expectation = expectation(description: "Fetch users should succeed")
        let mockUsers = [
            User(id: 1, name: "John Doe", email: "john@example.com", avatar: "https://example.com/avatar1.jpg"),
            User(id: 2, name: "Jane Doe", email: "jane@example.com", avatar: "https://example.com/avatar2.jpg")
        ]
        mockAPI.mockData = try! JSONEncoder().encode(mockUsers)
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].name, "John Doe")
        XCTAssertNil(viewModel.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }

    func testFetchUsersFailure() async {
        let expectation = expectation(description: "Fetch users should fail")
        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }
}
