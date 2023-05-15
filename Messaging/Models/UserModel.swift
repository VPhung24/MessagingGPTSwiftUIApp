//
//  UserModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserModel: Identifiable, Codable, Hashable, ObservableObject {
    @DocumentID var id: String?
    @Published var username: String?
    @Published var first: String?
    @Published var last: String?

    @Published var editMode: Bool = false
    @Published var editState: ProfileState = .NeedsFilled
    private var cancellables = Set<AnyCancellable>()

    init(id: String?, username: String?, first: String?, last: String?) {
        self.username = username
        self.first = first
        self.last = last
    }

    init() {

    }

    enum CodingKeys: String, CodingKey {
        case username
        case first
        case last
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.username == rhs.username
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        first = try container.decode(String.self, forKey: .first)
        last = try container.decode(String.self, forKey: .last)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(first, forKey: .first)
        try container.encode(last, forKey: .last)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func getUpdatedModel() {
        guard let id = id else {
            print("id does not exist")
            return
        }
        let docRef = Firestore.firestore().collection("users").document(id)

        docRef.getDocument { (document, error) in
            guard let document = document else {
                print("Error getting document: \(String(describing: error?.localizedDescription))")
                return
            }
            if document.exists {
                do {
                    let user = try document.data(as: UserModel.self)
                    self.first = user.first
                    self.last = user.last
                    self.username = user.username
                    self.editState = user.username == nil ? .NeedsFilled : .DoneMode
                } catch {
                    print("error decoding user model \(error.localizedDescription)")
                }
            } else {
                let userModel = UserModel(id: id, username: nil, first: nil, last: nil)
                self.updateUserModel(userModel)
                self.editState = .NeedsFilled
            }
        }
    }

    func updateFirestore() {
        self.updateUserModel(self)
        self.editMode = false
        self.editState = .DoneMode
    }

    func updateUserModel(_ user: UserModel) {
        guard let id = id else {
            print("id does not exist")
            return
        }

        let docRef = Firestore.firestore().collection("users").document(id)

        do {
            try docRef.setData(from: user, merge: true) { error in
                if let error = error {
                    print("Error adding user: \(error)")
                } else {
                    print("User added/updated successfully")
                }
            }
        } catch {
            print("error adding user \(error.localizedDescription)")
        }
    }
}
