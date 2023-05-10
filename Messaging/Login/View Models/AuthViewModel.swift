//
//  AuthViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 5/9/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import AuthenticationServices

class AuthViewModel: NSObject, ObservableObject {
    @Published var isSignedIn = false
    @Published var appUserUUID: String?

    let appleIDProvider = ASAuthorizationAppleIDProvider()

    override init() {
        super.init()

        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    self.appUserUUID = KeychainItem.currentUserIdentifier
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
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: String(data: appleIDCredential.identityToken!, encoding: .utf8)!,
                                                      rawNonce: nil)

            Auth.auth().signIn(with: credential) { (success, error) in
                guard let uuid = success?.user.uid else {
                    print(error?.localizedDescription ?? "error logging in")
                    return
                }

                self.saveUserInKeychain(uuid)
                self.appUserUUID = uuid
                self.isSignedIn = true
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
