//
//  PostsViewModel.swift
//  Social Media App
//
//  Created by alex on 4/23/23.
//

import Foundation
import UIKit

class PostsViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        fetchAllPosts()
    }
    
    func fetchAllPosts() {
        FirebaseManager.shared.firestore
            .collection("posts")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    print("failed to fetch posts \(error)")
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
    
    func getUserProfileImage(userUID: String, completion: @escaping (UIImage?) -> Void) {
        let ref = FirebaseManager.shared.storage.reference(withPath: userUID)
        ref.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print("error getting post image, \(error.localizedDescription)")
                completion(nil)
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
        }
    }
}
