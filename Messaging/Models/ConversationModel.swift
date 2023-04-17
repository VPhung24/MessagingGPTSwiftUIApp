//
//  ConversationModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation

struct Conversation: Identifiable {
    var id: String
    var user: String
    var lastMessage: String
}
