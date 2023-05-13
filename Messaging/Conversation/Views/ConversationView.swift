//
//  ConversationView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var viewModel = ConversationViewModel()
    @EnvironmentObject var user: UserModel
    let conversationId: String

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message, isFromCurrentUser: message.username == user.username)
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in
                        scrollToBottom(scrollViewProxy)
                    }
                }
            }

            Spacer()

            MessageInputView { message in
                viewModel.sendMessage(messageContent: message, username: user.username!)
            } sendMessageWithImage: { (message, image) in
                viewModel.sendMessageWithImage(messageContent: message, username: user.username!, image)
            }
            .padding(.bottom, 8)
        }
        .navigationBarTitle("Chat", displayMode: .inline)
        .onAppear {
            viewModel.fetchMessages(with: conversationId)
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeInOut(duration: 0.25)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

 struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConversationView(conversationId: "ja7rfmcX42WX3nN17kJa")
                .environmentObject(UserModel(id: "asdsad", username: "viv", first: "vivian", last: "phung"))
        }
    }
 }
