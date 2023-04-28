//
//  ChatView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    let currentUserId: String
    let conversationId: String

    init(userId: String, conversationId: String) {
        self.currentUserId = userId
        self.conversationId = conversationId
    }

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message, isFromCurrentUser: message.userId == currentUserId)
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in
                        scrollToBottom(scrollViewProxy)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            MessageInputView { message in
                viewModel.sendMessage(messageContent: message, userId: currentUserId)
            } sendMessageWithImage: { (message, image) in
                viewModel.sendMessageWithImage(messageContent: message, userId: currentUserId, image)
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
        ChatView(userId: "viv", conversationId: "ja7rfmcX42WX3nN17kJa")
    }
 }
