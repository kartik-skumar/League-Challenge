import SwiftUI

enum AppRoute {
    case login
    case userList
    case postList(user: User?)
    case userInfo(user: User?)
}

class Router: ObservableObject {
    @Published var currentRoute: AppRoute = .login

    func navigate(to route: AppRoute) {
        currentRoute = route
    }

    func goBack() {
        switch currentRoute {
        case .postList:
            currentRoute = .userList
        default:
            currentRoute = .login
        }
    }
}

