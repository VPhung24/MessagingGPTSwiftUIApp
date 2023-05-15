//
//  AuthViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 5/9/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

class AuthViewModel: NSObject, ObservableObject {
    @Published var isSignedIn = false
    @Published var showProfileView: Bool = false
    @Published var user: UserModel?

    let appleIDProvider = ASAuthorizationAppleIDProvider()

    override init() {
        super.init()

        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    let uuid = KeychainItem.currentUserIdentifier
                    self.getUserFrom(id: uuid) { model in
                        self.user = model
                    }
                    self.isSignedIn = true
                }
            case .revoked, .notFound:
                print("not signed in")
            default:
                break
            }
        }
    }

    func signInWithApple() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken {

            // Create Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: String(decoding: identityToken,
                                                                      as: UTF8.self),
                                                      rawNonce: nil)

            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                // User is signed in to Firebase with Apple.
                // Here we get the unique user identifier provided by Apple.
                guard let appleID = authResult?.user.providerData.first?.uid else { return }

                // Create a reference to the Firestore "users" collection.
                let usersRef = Firestore.firestore().collection("users")

                // Create a reference to the specific document for this user.
                let currentUserRef = usersRef.document(appleID)

                // Get the user document.
                currentUserRef.getDocument { (document, _) in
                    if let document = document, document.exists {
                        // The user document exists, the user has signed in before.
                        print("User exists: \(document.documentID)")
                        self.getUserFrom(id: document.documentID) { user in
                            self.user = user
                            self.isSignedIn = true
                        }
                    } else {
                        // The user document does not exist, this is a new user.
                        print("New user: \(appleID)")

                        let userModel = UserModel(id: nil, username: nil, first: nil, last: nil)
                        self.addUserToFirestore(appleID, user: userModel)
                        self.saveUserInKeychain(appleID)
                        self.getUserFrom(id: appleID) { user in
                            self.user = user
                            self.isSignedIn = true
                        }
                    }
                }
            }
        }
    }

    private func addUserToFirestore(_ userId: String, user: UserModel) {
        let userRef = Firestore.firestore().collection("users").document(userId)

        do {
            try userRef.setData(from: user) { error in
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

    private func getUserFrom(id: String, completion: @escaping (UserModel?) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(id)

        docRef.getDocument { (document, error) in
            guard let document = document else {
                print("Error getting document: \(String(describing: error?.localizedDescription))")
                completion(nil)
                return
            }
            if document.exists {
                do {
                    let user = try document.data(as: UserModel.self)
                    completion(user)
                } catch {
                    print("error decoding user model \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                let userModel = UserModel(id: id, username: nil, first: nil, last: nil)
                self.addUserToFirestore(id, user: userModel)
                completion(userModel)
            }
        }
    }

    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.vivianphung.MessagingGPT", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
