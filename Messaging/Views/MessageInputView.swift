//
//  MessageInputView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI

struct MessageInputView: View {
    @State var message: String = ""
    var sendMessage: (String) -> Void
    var sendMessageWithImage: (_ message: String, _ image: UIImage) -> Void

    @State private var showImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        HStack {
            TextField("Type a message...", text: $message)
                .padding(8)
                .background(Color(white: 0.95))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                showImagePicker.toggle()
            }) {
                Image(systemName: "photo")
                    .foregroundColor(.primary)
            }

            Button(action: {
                if !message.trimmingCharacters(in: .whitespaces).isEmpty {
                    sendMessage(message)
                    message = ""
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
            .disabled(message.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.bottom, 8)
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let inputImage = inputImage {
                sendMessageWithImage(message, inputImage)
                message = ""
            }
        }) {
            ImagePicker(image: $inputImage)
        }
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView { _ in
            print("send message")
        } sendMessageWithImage: { (_, _) in
            print("open image view")
        }

    }
}
