//
//  ChatView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ChatView: View {
    @State private var message = ""
    @ObservedObject var viewModel = ChatViewModel()
    let currentUserId: String
    let conversationId: String

    init(userId: String, conversationId: String) {
        self.currentUserId = userId
        self.conversationId = conversationId
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message,
                                    isFromCurrentUser: message.userId == currentUserId)
                    }
                }
            }
            .padding()

            Spacer()

            MessageInputView(message: $message) {
                viewModel.sendMessage(messageContent: message, userId: currentUserId)
                message = ""
            }
            .padding(.bottom, 8)
        }
        .navigationBarTitle("Chat", displayMode: .inline)
        .onAppear {
            viewModel.fetchMessages(with: conversationId)
        }
    }
}

 struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(userId: "viv", conversationId: "ja7rfmcX42WX3nN17kJa")
    }
 }
