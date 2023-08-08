//
//  SearchView.swift
//  Social Media App
//
//  Created by alex on 4/23/23.
//

import SwiftUI

struct SearchView: View {
    @State private var text = ""
    @ObservedObject var postsViewModel: PostsViewModel
    
    var body: some View {
        VStack {
            HStack {
                withAnimation(.default) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Search", text: $text)
                    }
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing, 8)
                    .transition(.move(edge: .trailing))
                }
            }
            .transition(.move(edge: .top))
            
            Spacer()
            
            ScrollView {
                ForEach(postsViewModel.posts.filter({ post in
                    text.isEmpty ? true : post.name.localizedStandardContains(text)
                })) { post in
                    PostComponent(post: post)
                        .padding(.bottom)
                }
            }
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(postsViewModel: PostsViewModel())
    }
}
