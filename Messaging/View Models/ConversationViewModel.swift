//
//  ConversationViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ConversationViewModel: ObservableObject {
    @Published var users: [UserModel] = [UserModel]()
    @Published var conversations = [ConversationModel]()
    private var cancellables = Set<AnyCancellable>()

    private var db = Firestore.firestore()

    init() {
        fetchConversation(for: "viv")
    }

    func fetchUsers() {
        db.collection("users")
            .addSnapshotListener { (querySnapshot, _) in
                guard let document = querySnapshot?.documents else {
                    print("no documnets")
                    return
                }

                self.users = document.compactMap({ (queryDocumentSnapshot) -> UserModel? in
                    return try? queryDocumentSnapshot.data(as: UserModel.self)
                })
            }
    }

    func fetchConversation(for user: String) {
        db.collection("conversations")
            .whereField("users", arrayContains: user)
            .addSnapshotListener { (querySnapshot, _) in
                guard let document = querySnapshot?.documents else {
                    print("no documnets")
                    return
                }

                self.conversations = document.compactMap({ (queryDocumentSnapshot) -> ConversationModel? in
                    var messages = [MessageModel]()
                    self.db.collection("conversation").document(queryDocumentSnapshot.documentID).collection("messages")
                        .getDocuments { (querySnapshot, _) in
                            messages = querySnapshot?.documents.compactMap({ (queryMessageSnapshot) -> MessageModel? in
                                return try? queryMessageSnapshot.data(as: MessageModel.self)
                            }) ?? []
                        }
                    print(messages)
                    return ConversationModel(id: queryDocumentSnapshot.documentID, users: queryDocumentSnapshot.data()["users"] as! [String], messages: messages)
                })
            }

    }
}
