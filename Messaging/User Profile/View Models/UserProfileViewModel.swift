//
//  UserProfileViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 5/10/23.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var username = ""
    @Published var firstName = ""
    @Published var lastName = ""

    // Fetch current user's data from Firestore
    func fetchUserData() {
        // Fetch data code goes here
    }

    // Save edited data to Firestore
    func saveUserData() {
        // Save data code goes here
    }
}
