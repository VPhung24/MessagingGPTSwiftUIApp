//
//  NewConversationViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class NewConversationViewModel: ObservableObject {
    @Published var users = [UserModel]()
    @Published var searchText = ""

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchUsers()
    }

    func fetchUsers() {
        db.collection("users")
            .order(by: "username")   // Assuming 'name' field exists
            .limit(to: 10)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting users: \(error)")
                    return
                }

                self.users = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: UserModel.self)
                } ?? []
            }
    }

    func getConversationId() -> String {
        return ""
    }

    func createConversation() {

    }

    var filteredUsers: [UserModel] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }
}
