//
//  UserProfileViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 10/9/2025.
//

import SwiftUI
import SwiftData
import Foundation

/// Used to store and manage details of the current user when they register
class UserProfileViewModel: ObservableObject {
    
    @Published var currentUser: UserProfile?
    @Published var isRegistered: Bool = false
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        loadUser()
    }
    
    func addUser(_ name: String,
                 _ age: String,
                 _ gender: String,
                 _ weight: String,
                 _ height: String,
                 _ calorieBudget: String,
                 _ proteinGoal: String,
                 _ carbGoal: String,
                 _ fatGoal: String,
                 _ weightGoal: String
    ) {
        let user = UserProfile(
            name: name,
            age: Int(age) ?? 0,
            gender: gender,
            weight: Double(weight) ?? 0.0,
            height: Double(height) ?? 0.0,
            calorieBudget: Int(calorieBudget) ?? 0,
            proteinGoal: Int(proteinGoal) ?? 0,
            carbGoal: Int(carbGoal) ?? 0,
            fatGoal: Int(fatGoal) ?? 0,
            weightGoal: Int(weightGoal) ?? 0
        )
        
        context.insert(user)
        try? context.save()
        
        currentUser = user
        self.isRegistered = true
        
        // DEBUG: Checking if user is registered
        print("User registered: \(self.currentUser?.name ?? "nil"), isRegistered: \(self.isRegistered)")
        
        
    }
    
    private func loadUser() {
        let descriptor = FetchDescriptor<UserProfile>()
        if let existing = try? context.fetch(descriptor).first {
            currentUser = existing
            isRegistered = true
        }
    }
}

