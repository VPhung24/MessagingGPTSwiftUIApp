//
//  ConversationListViewModel.swift
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

class ConversationListViewModel: ObservableObject {
    @Published var conversations = [ConversationModel]()
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private var userId: String?

    @Published var showSearchView: Bool = false
    @Published var showConversationView: Bool = false
    @Published var showProfileView: Bool = false

    @Published var showSelectedUser: String?

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

    func startConversation(with frenUserId: String) {
        if conversations.contains(where: { convo in
            convo.participants.contains { username in
                username == frenUserId
            }
        }) {
            // open convo
        } else {
            createNewConversation(with: frenUserId)
        }
    }

    func createNewConversation(with frenUserId: String) {
        guard let userId = userId else {
            // todo: userid should never be nil
            print("userid does not exist")
            return
        }
        let newConversation = ConversationModel(participants: [userId, frenUserId], name: frenUserId, lastMessage: "")
        do {
            try db.collection("conversations")
                .addDocument(from: newConversation)
        } catch {
            print("error starting new conversation: \(error.localizedDescription)")
        }
    }

    deinit {
        listener?.remove()
    }
}
