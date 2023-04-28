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
    var participants: [String]
    var name: String
    var lastMessage: String
    @ServerTimestamp var timestamp: Timestamp?

    enum CodingKeys: String, CodingKey {
        case id
        case participants
        case name
        case lastMessage
        case timestamp
    }
}
