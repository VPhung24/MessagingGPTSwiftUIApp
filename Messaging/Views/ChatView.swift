//
//  ChatView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ChatView: View {
    var conversation: Conversation
    
    // Sample data for messages
    let messages = [
        Message(id: "1", content: "Hey, how's it going?", isFromCurrentUser: false),
        Message(id: "2", content: "I'm doing great, thanks for asking!", isFromCurrentUser: true),
        Message(id: "3", content: "Did you watch the game last night?", isFromCurrentUser: false),
        Message(id: "4", content: "No, I missed it. What happened?", isFromCurrentUser: true)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        MessageView(message: message)
                            .padding(.leading, message.isFromCurrentUser ? 40 : 8)
                            .padding(.trailing, message.isFromCurrentUser ? -40 : 40)
                    }
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
            
            MessageInputView()
        }
        .navigationBarTitle(conversation.user, displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(conversation: Conversation(id: "1", user: "John", lastMessage: "Hey, how's it going?"))
    }
}
