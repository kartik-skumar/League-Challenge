import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    func makeRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}

public enum APIEndpoint: Endpoint {
    case login(username: String?, password: String?)
    case posts
    case users
    case postsFromUser(userId: Int)

    var path: String {
        let baseURL = "https://engineering.league.dev/challenge/api"
        switch self {
        case .login:
            return "\(baseURL)/login"
        case .posts:
            return "\(baseURL)/posts"
        case .users:
            return "\(baseURL)/users"
        case .postsFromUser(let userId):
            return "\(baseURL)/posts?userId=\(userId)"
        }
    }

    var method: String {
        switch self {
        case .login:
            return "GET"
        case .posts, .users, .postsFromUser:
            return "GET"
        }
    }

    var headers: [String: String]? {
        switch self {
        case .login:
            return nil
        case .posts, .users, .postsFromUser:
            if let apiKey = KeychainHelper.shared.read(key: "apiKey") {
                return ["x-access-token": apiKey]
            } else {
                return nil
            }
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .login(let username, let password):
            if let username = username, let password = password {
                return nil
                // as all requests are GET, commenting this line
                //return ["username": username, "password": password]
            }
            return nil
        default:
            return nil
        }
    }
}
