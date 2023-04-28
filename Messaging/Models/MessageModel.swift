//
//  MessageModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct MessageModel: Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var userId: String
    var timestamp: Timestamp
    var conversationId: String

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case userId
        case timestamp
        case conversationId
    }
}
