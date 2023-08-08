//
//  ProfileViewModel.swift
//  Social Media App
//
//  Created by alex on 4/23/23.
//

import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        getUserPosts()
    }
    
    func getUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection("posts")
            .whereField("useruid", isEqualTo: uid)
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    print("Failed to fetch posts \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let post = Post(data: data)
                    self.posts.append(post)
                    self.posts.sort { $0.timestamp > $1.timestamp }
                })
            }
    }
}
