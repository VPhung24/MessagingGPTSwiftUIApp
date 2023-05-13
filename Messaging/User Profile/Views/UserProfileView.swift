//
//  UserProfileView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var user: UserModel

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: $user.first.toUnwrapped(defaultValue: ""))
                    .disabled(!user.editMode)
                TextField("Last Name", text: $user.last.toUnwrapped(defaultValue: ""))
                    .disabled(!user.editMode)
                TextField("Username", text: $user.username.toUnwrapped(defaultValue: ""))
                    .disabled(!user.editMode)
                Button(action: {
                    if user.editMode {
                        user.updateFirestore()
                   } else {
                        user.editMode = true
                    }
                }) {
                    Text(user.editMode ? "Save" : "Edit")
                }
            }

        }
        .navigationTitle(user.editMode ? "Edit Profile" : "Profile")

    }
}

// Form {
//    Section {
//        TextField("First Name", text: $viewModel.firstName)
//            .disabled(!viewModel.editMode)
//        TextField("Last Name", text: $viewModel.lastName)
//            .disabled(!viewModel.editMode)
//
//        TextField("Username", text: $viewModel.username)
//            .disabled(!viewModel.editMode)
//    }
//    Button(action: {
//        if viewModel.editMode {
//            viewModel.saveUserData()
//            presentationMode.wrappedValue.dismiss()
//        } else {
//            viewModel.editMode = true
//        }
//    }) {
//        Text(viewModel.editMode ? "Save" : "Edit")
//    }
// }

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserModel(id: "sasdasd", username: "viv", first: "sadasd", last: "asdd"))
    }
}
