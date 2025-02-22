import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Spacer()
            Text("League Social Media")
                .font(.headline)
            Spacer()
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Spacer()
            Button("Login") {
                Task {
                    await authViewModel.login(username: username, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Button("Continue as Guest") {
                Task {
                    await authViewModel.continueAsGuest()
                }
            }
            .padding()
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        .onChange(of: authViewModel.isAuthenticated) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.25)) {
                    router.navigate(to: .userList)
                }
            }
        }
    }
}
#Preview {
    LoginView()
}
