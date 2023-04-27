//
//  ConversationsListView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationsListView: View {
    @StateObject var viewModel = ConversationViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.messages, id: \.first?.id) { conversation in
                    NavigationLink(destination: ChatView(message: conversation)) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(conversation.first?.toConversationName ?? "convo name")
                                    .font(.headline)

//                                Text(conversation.messages.last?.content ?? "")
                                Text(conversation.last?.content ?? "last message")
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
            .navigationBarTitle("Conversations")
        }
    }
}

struct ConversationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsListView()
    }
}
