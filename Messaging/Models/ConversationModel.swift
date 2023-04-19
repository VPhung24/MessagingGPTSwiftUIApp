//
//  ConversationModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ConversationModel: Identifiable, Codable {
    @DocumentID var id: String?
    var users: [String]
    var messages: [MessageModel]

    enum CodingKeys: String, CodingKey {
        case id
        case users
        case messages
    }
}
