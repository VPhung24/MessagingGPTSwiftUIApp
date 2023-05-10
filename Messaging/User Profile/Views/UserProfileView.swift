//
//  UserProfileView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Username")) {
                    TextField("Username", text: $viewModel.username)
                }

                Section(header: Text("First Name")) {
                    TextField("First Name", text: $viewModel.firstName)
                }

                Section(header: Text("Last Name")) {
                    TextField("Last Name", text: $viewModel.lastName)
                }

                Button(action: {
                    viewModel.saveUserData()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
            .navigationTitle("Edit Profile")
        }
        .onAppear(perform: {
            viewModel.fetchUserData()
        })
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
