import SwiftUI

struct AppRouterView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        switch router.currentRoute {
        case .login:
            LoginView()
        case .userList:
            UserListView()
        case .postList(let user):
            PostListView(user: user)
        case .userInfo(let user):
            UserInfoView(user: user)
        }
    }
}

