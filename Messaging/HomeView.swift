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
                ConversationsListView()
                    .environmentObject(authViewModel)

        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

enum ProfileState {
    case NeedsFilled
    case EditMode
    case DoneMode
}
