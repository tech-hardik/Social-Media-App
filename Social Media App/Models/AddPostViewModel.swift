//
//  AddPostViewModel.swift
//  Social Media App
//
//  Created by alex on 4/22/23.
//

import Foundation
import Firebase

class AddPostViewModel {
    func addPost(name: String, postTitle: String, image: UIImage?, date: Date) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("posts").document()
        ref.setData([
            "name": name,
            "title": postTitle,
            "id": ref.documentID as String,
            "timestamp": date,
            "useruid": uid
        ])
        
        guard let image = image else { return }
        
        savePostImage(image: image, documentID: ref.documentID as String)
    }
    
    func savePostImage(image: UIImage, documentID: String) {
        let ref = FirebaseManager.shared.storage.reference(withPath: documentID)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("error getting post image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("error uploading post image \(error.localizedDescription)")
                    return
                }
                
                if let url = url {
                    print("post image url: \(url)")
                    Firestore.firestore()
                        .collection("posts")
                        .document(documentID)
                        .setData(["imageurl": url.absoluteString], merge: true)
                }
            }
        }
    }
}
