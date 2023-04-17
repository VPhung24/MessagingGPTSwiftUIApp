//
//  MessagingViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import Combine

class MessagingViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()

    @Published var conversations: [Conversation] = [Conversation(id: "1", user: "Jamey Gannon", lastMessage: "YEEEEE really excited"),
                                                    Conversation(id: "2", user: "Jen Aprahamian", lastMessage: "Still cant believe Joe and Taylor are over"),
                                                    Conversation(id: "3", user: "Cristina Vanko", lastMessage: "HE DID WHAT?")]

    init() {

    }
}
