import SwiftUI

struct UserInfoView: View {
    @StateObject var userViewModel = UserViewModel()
    @EnvironmentObject var router: Router
    let user: User?

    var body: some View {
        VStack {
            if let user = user {
                AsyncImage(url: URL(string: user.avatar))
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                Text(user.name).font(.title)
                HStack {
                    Text(user.email)
                    if !userViewModel.isValidEmailDomain(user.email) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
            } else {
                ProgressView("Loading...")
            }
        }
    }
}
