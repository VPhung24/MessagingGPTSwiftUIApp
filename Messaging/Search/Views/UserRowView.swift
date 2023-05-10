//
//  UserRowView.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import SwiftUI

struct UserRowView: View {
    var name: String
    var username: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text(username)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView(name: "viv", username: "viv")
    }
}
