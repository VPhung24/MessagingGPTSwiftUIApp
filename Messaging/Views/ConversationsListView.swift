//
//  ConversationsListView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationsListView: View {
    // Sample data for conversations
    let conversations = [
        Conversation(id: "1", user: "John", lastMessage: "Hey, how's it going?"),
        Conversation(id: "2", user: "Jane", lastMessage: "Catch you later!"),
        Conversation(id: "3", user: "Mike", lastMessage: "Did you watch the game last night?")
    ]
    
    var body: some View {
        NavigationView {
            List(conversations) { conversation in
                NavigationLink(destination: ChatView(conversation: conversation)) {
                    HStack {
                        Text(conversation.user)
                            .font(.headline)
                        Spacer()
                        Text(conversation.lastMessage)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Conversations")
        }
    }
}

struct ConversationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsListView()
    }
}
