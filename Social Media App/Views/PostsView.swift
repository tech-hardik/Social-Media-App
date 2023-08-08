//
//  PostsView.swift
//  Social Media App
//
//  Created by alex on 4/22/23.
//

import SwiftUI
import Kingfisher

struct PostComponent: View {
    let post: Post
    var postsViewModel = PostsViewModel()
    @State private var profileImage: UIImage?
    @State private var isLoadingImage = false
    
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal)
            
            HStack {
                if isLoadingImage {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(
                        RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                        )
                        .padding(.leading)
                } else if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(
                        RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                        )
                        .padding(.leading)
                }
                
                Text(post.name)
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            
            HStack {
                Text(post.postTitle)
                    .bold()
                
                Spacer()
                
                Text(post.timestamp.formatted())
                    .font(.caption2)
            }
            .padding()
            
            if let url = URL(string: post.imageURL) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 200)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            isLoadingImage = true
            postsViewModel.getUserProfileImage(userUID: post.userUID) { image in
                profileImage = image
                isLoadingImage = false
            }
        }
    }
}

struct PostsView: View {
    @StateObject var postsViewModel = PostsViewModel()
    
    @State private var showSearchView = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(postsViewModel.posts) { post in
                        PostComponent(post: post)
                            .padding(.bottom)
                    }
                }
            }
            .refreshable {
                postsViewModel.posts = [Post]()
                postsViewModel.fetchAllPosts()
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSearchView.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showSearchView) {
                SearchView(postsViewModel: postsViewModel)
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
