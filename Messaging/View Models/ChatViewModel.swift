//
//  ChatViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/27/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject {
    @Published var messages = [MessageModel]()
    var conversationId: String?
    private var db = Firestore.firestore()

    func fetchMessages(with conversationId: String) {
        self.conversationId = conversationId
        db
            .collection("conversations")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .getDocuments { querySnapshot, error in

                if let error = error {
                    print("Error fetching messages: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }

                    self.messages = documents.compactMap { document -> MessageModel? in
                        do {
                            return try document.data(as: MessageModel.self)
                        } catch {
                            print("Error decoding message: \(error)")
                            return nil
                        }
                    }

                    print(self.messages)
                }
            }

    }

    func sendMessage(messageContent: String, userId: String) {
        guard let conversationId = conversationId else {
            return
        }

        let messagesCollection = db.collection("conversations").document(conversationId).collection("messages")
        do {
            let newMessageDocument = try messagesCollection.addDocument(from: MessageModel(content: messageContent,
                                                                                           userId: userId,
                                                                                           timestamp: Timestamp(date: Date()),
                                                                                           conversationId: conversationId))
            print("new message document \(newMessageDocument)")
        } catch {
            print("error adding document")
        }

    }
}
