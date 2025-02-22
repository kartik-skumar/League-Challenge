import SwiftUI

struct PostListView: View {
    @StateObject private var postViewModel = PostViewModel(apiService: APIHelper.shared)
    @EnvironmentObject var router: Router
    @State private var showUserInfo: Bool = false
    let user: User?
    
    var body: some View {
        NavigationView {
            List(postViewModel.posts) { post in
                VStack(alignment: .leading, spacing: 10.0) {
                    HStack {
                        if let user = user {
                            AsyncImage(url: URL(string: user.avatar))
                                .frame(width: 40.0, height: 40.0)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle")
                                .frame(width: 40.0, height: 40.0)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text(post.title).font(.headline)
                            Text(user?.name ?? "Anonymous")
                                .font(.caption)
                        }
                    }
                    Text(post.body).font(.subheadline).foregroundColor(.gray)
                }
                .padding()
                .onTapGesture {
                    showUserInfo = true
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            router.navigate(to: .userList)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Users")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await postViewModel.fetchPosts(userId: user?.id ?? 1)
            }
        }
        .sheet(isPresented: $showUserInfo) {
            UserInfoView(user: user)
        }
    }
}
