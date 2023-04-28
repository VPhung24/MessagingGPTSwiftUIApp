//
//  ConversationsViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ConversationsViewModel: ObservableObject {
    @Published var conversations = [ConversationModel]()
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private var userId: String?

    func fetchConversations(userId: String) {
        self.userId = userId
        listener = db.collection("conversations")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching conversations: \(error)")
                } else {
                    self.conversations = querySnapshot?.documents.compactMap { document -> ConversationModel? in
                        do {
                            return try document.data(as: ConversationModel.self)
                        } catch {
                            print("Error decoding conversation: \(error)")
                            return nil
                        }
                    } ?? []
                }
            }
    }

    deinit {
        listener?.remove()
    }
}
