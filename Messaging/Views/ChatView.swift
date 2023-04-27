//
//  ChatView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct ChatView: View {
    var message: [MessageModel]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(message) { message in
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
        .navigationBarTitle(message.first!.toConversationName, displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(message: [MessageModel(content: "hello", fromUser: "viv", toConversationName: "jen")])
    }
}
