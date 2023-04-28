//
//  MessageInputView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var message: String
    var sendMessage: () -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $message)
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
            .disabled(message.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.bottom, 8)
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(message: .constant("hello")) {
            print("insert")
        }
    }
}
