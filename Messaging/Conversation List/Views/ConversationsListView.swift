//
//  ConversationsListView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationsListView: View {
    @ObservedObject var viewModel = ConversationListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LazyView { ConversationView(conversationId: viewModel.showConversationId!)
                        .environmentObject(authViewModel.user!)
                },
                               isActive: $viewModel.showConversationView) {
                    EmptyView()
                }

                List {
                    ForEach(viewModel.conversations) { conversation in
                        NavigationLink(destination: LazyView { ConversationView(conversationId: conversation.id!)
                                .environmentObject(authViewModel.user!)
                        }) {
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
                    viewModel.fetchConversations(username: authViewModel.user!.username!)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("compose message")
                            print("userId: \(String(describing: authViewModel.user!.id))")

                            viewModel.showNewConversationView = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("compose message")

                            viewModel.showProfileView = true
                        } label: {
                            Image(systemName: "person.fill")
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showNewConversationView) {
                    NewConversationView { username in
                        viewModel.showNewConversationView = false
                        viewModel.startConversation(with: username, and: authViewModel.user!.username!)
                    }
                        .padding(.top, 10)
                }
                .sheet(isPresented: $viewModel.showProfileView) {
                    UserProfileView()
                        .environmentObject(authViewModel.user!)
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
        ConversationsListView()
            .environmentObject(UserModel(id: "akwhdshas", username: "viv", first: "hello", last: "hehe"))
    }
}
