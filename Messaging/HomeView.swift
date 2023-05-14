//
//  HomeView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/9/23.
//

import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var user: UserModel = UserModel(id: nil, username: nil, first: nil, last: nil)

    var body: some View {
        if authViewModel.isSignedIn {
            // todo: fix so edit mode doesn't leave conversation 
            if user.username == nil || user.username == "" || user.editMode {
                UserProfileView()
                    .environmentObject(user)
                    .onAppear {
                        user.id = authViewModel.appUserUUID
                        user.getUpdatedModel()
                    }
            } else {
                ConversationsListView()
                    .environmentObject(user)
                    .onAppear {
                        user.id = authViewModel.appUserUUID
                        user.getUpdatedModel()
                    }
            }

        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}
