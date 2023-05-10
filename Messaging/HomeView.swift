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

    var body: some View {
        if authViewModel.isSignedIn {
            ConversationsListView(userId: authViewModel.username)
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}
