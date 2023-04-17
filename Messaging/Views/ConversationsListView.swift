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
            List {
                ForEach(conversations) { conversation in
                    NavigationLink(destination: ChatView(conversation: conversation)) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(conversation.user)
                                    .font(.headline)

                                Text(conversation.lastMessage)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("GPT Messages")
        }
    }
}

struct ConversationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsListView()
    }
}
