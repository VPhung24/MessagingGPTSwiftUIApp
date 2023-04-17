//
//  MessageView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import SwiftUI

struct MessageView: View {
    var message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if !message.isFromCurrentUser {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Spacer()
            }

            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(10)
                    .background(message.isFromCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isFromCurrentUser ? .white : .black)
                    .cornerRadius(16, corners: message.isFromCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])

                Text("2:34 PM")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if message.isFromCurrentUser {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(id: "1", content: "Test message", isFromCurrentUser: false))
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
