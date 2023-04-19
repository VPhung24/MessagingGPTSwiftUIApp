//
//  MessageView.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import SwiftUI

struct MessageView: View {
    var message: MessageModel

    var body: some View {

        HStack(alignment: .bottom, spacing: 12) {
            if message.fromUser != "viv" {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Spacer()
            }

            VStack(alignment: message.fromUser == "viv" ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(10)
                    .background(message.fromUser == "viv" ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.fromUser == "viv" ? .white : .black)
                    .cornerRadius(16, corners: message.fromUser == "viv" ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])

                Text("2:34 PM")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !(message.fromUser == "viv") {
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageView(message: MessageModel(content: "user user",
                                              fromUser: "jen", time: Date(timeIntervalSince1970: TimeInterval(TimeInterval(NSDate().timeIntervalSince1970)))))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .previewDisplayName("Default preview")

            MessageView(message: MessageModel(content: "hello world", fromUser: "viv", time: Date(timeIntervalSince1970: TimeInterval(TimeInterval(NSDate().timeIntervalSince1970)))))
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
