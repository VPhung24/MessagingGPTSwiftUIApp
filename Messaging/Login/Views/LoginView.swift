//
//  LoginView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/9/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: \
    AuthViewModel

    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn, onRequest: { _ in
                authViewModel.signInWithApple()
            }, onCompletion: { _ in

            })
            .frame(width: 280, height: 60)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
