//
//  NewConversationView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import SwiftUI

struct NewConversationView: View {
    @StateObject var viewModel = NewConversationViewModel()

    var body: some View {
        VStack {
            SearchView(text: $viewModel.searchText)
            List {
                ForEach(viewModel.filteredUsers, id: \.self) { user in
                    UserRowView(name: user.first, username: user.username)
                }
            }
        }
    }
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NewConversationView()
    }
}
