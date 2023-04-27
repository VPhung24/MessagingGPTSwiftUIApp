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
    @Published var users = [UserModel]()
    @Published var conversations = [ConversationModel]()
    @Published var messages = [[MessageModel]]()
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
        let conversationCollection = db.collection("conversations")

        conversationCollection
            .whereField("users", arrayContains: user)
            .getDocuments(completion: { (querySnapshot, _) in
                guard let document = querySnapshot?.documents else {
                    print("no documnets")
                    return
                }

                self.conversations = document.compactMap({ (queryDocumentSnapshot) -> ConversationModel? in
                    do {
                        let convo = try queryDocumentSnapshot.data(as: ConversationModel.self)

                        guard let id = convo.id else {
                            return nil
                        }
                        conversationCollection.document(id).collection("messages").getDocuments(completion: { (messsageQuerySnapshot, messageError) in
                                guard let messagesDocuments = messsageQuerySnapshot?.documents else {
                                    print("no message document with error: ", messageError ?? "no message error")
                                    return
                                }

                                self.messages.append(
                                    messagesDocuments.compactMap({ (messageSnapshot) -> MessageModel? in
                                        do {
                                            let theMessage = try messageSnapshot.data(as: MessageModel.self)
                                            return theMessage
                                        } catch {
                                            print("error decoding message: ", error)
                                            return nil
                                        }
                                    })

                                )

                            })

                        return convo
                    } catch {
                        print(error)
                        return nil
                    }

                })
            })
    }
}
