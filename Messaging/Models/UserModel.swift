//
//  UserModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserModel: Identifiable, Codable {
    @DocumentID var username: String?
    var first: String
    var last: String

    var id: String? { username }

    enum CodingKeys: String, CodingKey {
        case username
        case first
        case last
    }
}
