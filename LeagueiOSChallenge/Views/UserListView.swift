import SwiftUI

struct UserListView: View {
    @StateObject private var userViewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @State private var showGuestExitAlert: Bool = false

    fileprivate func exitAndLogout() {
        authViewModel.logout()
        withAnimation(.easeInOut(duration: 0.25)) {
            router.navigate(to: .login)
        }
    }
    
    var body: some View {
        NavigationView {
            List(userViewModel.users) { user in
                HStack {
                    AsyncImage(url: URL(string: user.avatar))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    Text(user.name)
                        .font(.headline)

                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        router.navigate(to: .postList(user: user))
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(authViewModel.isGuestUser ? "Exit" : "Logout") {
                        if authViewModel.isGuestUser {
                            self.showGuestExitAlert = true
                        } else {
                            exitAndLogout()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await userViewModel.fetchUsers()
                }
            }
            .alert(isPresented: $showGuestExitAlert) {
                Alert(title: Text("Exit"),
                      message: Text("Thank you for trialing this app"),
                      dismissButton: .default(
                        Text("OK"),
                        action: {
                            exitAndLogout()
                }))
            }
        }
    }
}
