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
        HStack(alignment: .bottom, spacing: 12) {
            if isFromCurrentUser {
                Spacer()
            }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if let photoURL = message.photoURL, let url = URL(string: photoURL) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if message.content != "" {
                    Text(message.content)
                        .padding(10)
                        .background(isFromCurrentUser ? Color.blue : Color(.systemGray5))
                        .foregroundColor(isFromCurrentUser ? .white : .black)
                        .cornerRadius(16, corners: isFromCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                }

                Text(timestampToString(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !isFromCurrentUser {
                Spacer()
            }
        }
        .padding(.vertical, 4)
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
