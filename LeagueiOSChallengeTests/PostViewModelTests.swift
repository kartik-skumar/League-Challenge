import XCTest
@testable import LeagueiOSChallenge

final class PostViewModelTests: XCTestCase {
    var viewModel: PostViewModel!
    var mockAPI: MockAPIHelper!

    override func setUp() async throws {
        try await super.setUp()
        mockAPI = MockAPIHelper()
        viewModel = PostViewModel(apiService: mockAPI)
    }

    override func tearDown() async throws {
        viewModel = nil
        mockAPI = nil
        try await super.tearDown()
    }

    func testFetchPostsSuccess() async {
        let expectation = expectation(description: "Fetch posts should succeed")
        let mockPosts = [
            Post(userId: 1, id: 1, title: "Test Post 1", body: "Test Body 1"),
            Post(userId: 1, id: 2, title: "Test Post 2", body: "Test Body 2")
        ]
        mockAPI.mockData = try! JSONEncoder().encode(mockPosts)
        await viewModel.fetchPosts(userId: 1)
        expectation.fulfill()
        XCTAssertEqual(viewModel.posts.count, 2)
        XCTAssertNil(viewModel.errorMessage)
        await fulfillment(of: [expectation])
    }

    func testFetchPostsFailure() async {
        let expectation = expectation(description: "Fetch posts should fail")
        await viewModel.fetchPosts(userId: 1)
        XCTAssertEqual(viewModel.posts.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
        expectation.fulfill()
        await fulfillment(of: [expectation])
    }
}
