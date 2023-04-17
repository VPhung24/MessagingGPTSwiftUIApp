//
//  MessageInputView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct MessageInputView: View {
    @State private var messageText = ""
    
    var body: some View {
        HStack {
            TextField("Type a message...", text: $messageText)
                .padding(8)
                .background(Color(white: 0.95))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
        }
        .padding(.bottom, 8)
    }
    
    func sendMessage() {
        print("Sending message: \(messageText)")
        // Replace this with the functionality to send the message to your backend service
        messageText = ""
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView()
    }
}
