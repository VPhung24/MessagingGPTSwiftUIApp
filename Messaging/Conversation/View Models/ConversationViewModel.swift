//
//  ConversationViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/27/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class ConversationViewModel: ObservableObject {
    @Published var messages = [MessageModel]()
    var conversationId: String?

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchMessages(with conversationId: String) {
        self.conversationId = conversationId
        listener = db
            .collection("conversations")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in

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
        let message = MessageModel(content: messageContent,
                                   userId: userId,
                                   timestamp: Timestamp(date: Date()),
                                   conversationId: conversationId)

        let messagesCollection = db.collection("conversations").document(conversationId).collection("messages")
        do {

            let newMessageDocument = try messagesCollection.addDocument(from: message)
            print("new message document \(newMessageDocument)")
        } catch {
            print("error adding document")
            return
        }

//        updateConversationLastMessage(message)
    }

    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to compress image.")
            completion(nil)
            return
        }

        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("message_images/\(imageName).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image download URL: \(error)")
                    completion(nil)
                    return
                }

                completion(url?.absoluteString)
            }
        }
    }

    func sendMessageWithImage(messageContent: String, userId: String, _ image: UIImage) {
        guard let conversationId = conversationId else {
            return
        }

        uploadImage(image) { [weak self] photoURL in
            guard let self = self, let photoURL = photoURL else { return }
            let message = MessageModel(content: messageContent, userId: userId, timestamp: Timestamp(date: Date()), conversationId: conversationId, photoURL: photoURL)

            do {
                try self.db.collection("conversations")
                    .document(conversationId)
                    .collection("messages")
                    .addDocument(from: message) { error in
                        if let error = error {
                            print("Error sending message with image: \(error)")
                        } else {
                            print("Message with image sent successfully.")
                        }
                    }
            } catch {
                print("sendMessageWithImage error: \(error)")
                return
            }

//            updateConversationLastMessage(message)
        }
    }

    private func updateConversationLastMessage(_ message: MessageModel) {
        guard let conversationId = conversationId else {
            return
        }

        let conversationRef = db.collection("conversations").document(conversationId)
        conversationRef.updateData([
            "lastMessage": message.content,
            "lastMessageTimestamp": message.timestamp
        ]) { error in
            if let error = error {
                print("Error updating conversation last message: \(error)")
            } else {
                print("Conversation last message updated successfully.")
            }
        }
    }

    deinit {
        listener?.remove()
    }
}
