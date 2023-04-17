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
        Conversation(id: "1", user: "Jamey Gannon", lastMessage: "YEEEEE really excited"),
        Conversation(id: "2", user: "Jen Aprahamian", lastMessage: "Still cant believe Joe and Taylor are over"),
        Conversation(id: "3", user: "Cristina Vanko", lastMessage: "HE DID WHAT?")
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
            .navigationBarTitle("Messages")
        }
    }
}

struct ConversationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsListView()
    }
}
