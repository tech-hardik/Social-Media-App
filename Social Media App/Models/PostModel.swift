//
//  PostModel.swift
//  Social Media App
//
//  Created by alex on 4/23/23.
//

import Foundation
import Firebase

struct Post: Decodable, Identifiable {
    var id: String
    var postTitle: String
    var timestamp: Date
    var name: String
    var userUID: String
    var imageURL: String
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.postTitle = data["title"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.name = data["name"] as? String ?? ""
        self.userUID = data["useruid"] as? String ?? ""
        self.imageURL = data["imageurl"] as? String ?? ""
    }
}
