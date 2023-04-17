//
//  MessageModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation

struct Message: Identifiable {
    var id: String
    var content: String
    var isFromCurrentUser: Bool
}
