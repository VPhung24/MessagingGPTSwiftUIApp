//
//  ChatView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ChatView: View {
    var conversation: ConversationModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversation.messages) { message in
                        MessageView(message: message)
                            .padding(EdgeInsets(top: 0,
                                                leading: message.fromUser == "viv" ? 40 : 8,
                                                bottom: 0,
                                                trailing: message.fromUser == "viv" ? 8 : 40))
                    }
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)

            MessageInputView()
        }
        .navigationBarTitle(conversation.users.last ?? "debug", displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(conversation: ConversationModel(users: ["viv", "jen"], messages: [MessageModel(content: "hello world", fromUser: "viv", time: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 30))), MessageModel(content: "hello world", fromUser: "jen", time: Date(timeIntervalSince1970: TimeInterval(integerLiteral: 30)))]))
    }
}
