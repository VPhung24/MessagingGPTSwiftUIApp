//
//  MessageView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Kingfisher

struct MessageView: View {
    let message: MessageModel
    let isFromCurrentUser: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            if isFromCurrentUser {
                Spacer()
            }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
                if let photoURL = message.photoURL, let url = URL(string: photoURL) {
                    ChatBubble(direction: isFromCurrentUser ? .right : .left) {
                        KFImage(url)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 70,
                                   height: 200).aspectRatio(contentMode: .fill)
                    }
                }

                if message.content != "" {
                    ChatBubble(direction: isFromCurrentUser ? .right : .left) {
                        Text(message.content)
                            .padding(EdgeInsets(top: 10,
                                                leading: isFromCurrentUser ? 15 : 20,
                                                bottom: 10,
                                                trailing: isFromCurrentUser ? 20 : 15))
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                }
            }

            if !isFromCurrentUser {
                Spacer()
            }
        }
    }

    private func timestampToString(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = timestamp.dateValue()
        return dateFormatter.string(from: date)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageView(message: MessageModel(content: "hello viv", userId: "jen", timestamp: Timestamp(date: Date()), conversationId: "ja7rfmcX42WX3nN17kJas"), isFromCurrentUser: false)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Default preview")

            MessageView(message: MessageModel(content: "hello jen", userId: "viv", timestamp: Timestamp(date: Date()), conversationId: "ja7rfmcX42WX3nN17kJa"), isFromCurrentUser: true)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("fromCurrentUserPreview")

            MessageView(message: MessageModel(content: "hello jen", userId: "viv", timestamp: Timestamp(date: Date()), conversationId: "ja7rfmcX42WX3nN17kJa", photoURL: "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492__340.jpg"), isFromCurrentUser: true)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("imagePreviewWText")

            MessageView(message: MessageModel(content: "", userId: "viv", timestamp: Timestamp(date: Date()), conversationId: "ja7rfmcX42WX3nN17kJa", photoURL: "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492__340.jpg"), isFromCurrentUser: false)
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("imagePreviewWText")
        }
    }
}

struct CornerRadiusStyle: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CornerRadiusStyle(cornerRadius: radius, corners: corners))
    }
}
