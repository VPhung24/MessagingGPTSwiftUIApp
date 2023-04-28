//
//  ConversationsListView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationsListView: View {
    @ObservedObject var viewModel = ConversationsViewModel()
    let userId: String

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink(destination: ChatView(userId: userId, conversationId: conversation.id ?? "")) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(conversation.name)
                                    .font(.headline)

                                Text(conversation.lastMessage)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Conversations")
            .onAppear {
                viewModel.fetchConversations(userId: userId)
            }
        }
    }
}

struct ConversationRow: View {
    var conversation: ConversationModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(conversation.name)
                .font(.headline)
            Text(conversation.lastMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical)
    }
}

struct ConversationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsListView(userId: "viv")
    }
}
