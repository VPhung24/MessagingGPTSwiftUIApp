//
//  ConversationsListView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationsListView: View {
    @ObservedObject var viewModel = ConversationsViewModel()
    @State var showSearchView: Bool = false
    @State var showConversationId: String?
    @State var showConversation: Bool = false
    let userId: String

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ChatView(userId: userId, conversationId: showConversationId ?? ""), isActive: $showConversation) {
                    EmptyView()
                }

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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("compose message")
                            print("userId: \(userId)")

                            self.showSearchView = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("compose message")
                        } label: {
                            Image(systemName: "person.fill")
                        }
                    }
                }
                .sheet(isPresented: $showSearchView) {
                    NewConversationView()
                        .padding(.top, 10)
                }
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
