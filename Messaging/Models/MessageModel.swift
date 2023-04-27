//
//  MessageModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MessageModel: Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var fromUser: String
    var toConversationName: String
    @ServerTimestamp var time: Timestamp?

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case fromUser
        case toConversationName
        case time
    }
}
