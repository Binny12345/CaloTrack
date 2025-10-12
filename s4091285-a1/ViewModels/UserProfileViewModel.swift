//
//  UserProfileViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 10/9/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

/// Used to store and manage details of the current user when they register
@MainActor
class UserProfileViewModel: ObservableObject {
    
    // State Variables
    @Published var currentUser: UserProfile?
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isRegistered: Bool = false
    
    // Connects to FirestoreService file, Listener and current user's UID
    private var firestoreService = FirestoreService()
    private var listener: ListenerRegistration?
    private var uid: String? { Auth.auth().currentUser?.uid }
    
    // Non-async initialiser for testing purposes
    convenience init(mock: Bool = false) {
        self.init()
        if mock {
            self.currentUser = nil
            self.isRegistered = false
        }
    }
    
    /// Default initializer for Main app (doesn’t fetch immediately)
    init() {
        self.currentUser = nil
        self.isRegistered = false
    }
    
    /// Initialiser for testing purposes
    init(forTesting: Bool = false) async throws {
        if !forTesting {
           await fetchProfile()
        } else {
            self.currentUser = nil
        }
    }
    
    // MARK: - Fetch the Logged Profile
    
    /// Loads the profile for the signed-in user
    func fetchProfile() async {
        guard let uid else {
            self.error = "No User was signed in"
            self.isRegistered = false
            return
        }
        
        isLoading = true
        do {
            if let profile = try await firestoreService.fetchUserProfile(uid: uid) {
                // If user exist, set current user make them registered
                self.currentUser = profile
                self.isRegistered = true
            } else {
                self.currentUser = nil
                self.isRegistered = false
            }
        } catch {
            self.error = error.localizedDescription
            self.isRegistered = false
        }
        isLoading = false
    }
    
    /// Sets a live listener on the user's profile
    func listenToProfile() {
        guard let uid else { return }
        
        listener?.remove() // Resets listener
        
        listener = firestoreService.listenToUserProfile(uid: uid) { [weak self] profile in
            Task { @MainActor in
                self?.currentUser = profile
                self?.isRegistered = (profile != nil)
            }
        }
    }
    
    // MARK: - Save Profile
    /// Saves the completed user profile after FormView is completed
    /// - Parameter name: User's name
    /// - Parameter age: Age that user inputted
    /// - Parameter weight: Weight that user inputted
    /// - Parameter height: Height that user inputted
    /// - Parameter gender: Gender that user inputted
    /// - Parameter calorieBudget: Budget that user inputted
    /// - Parameter proteinGoal: Protein goal that the user inputted
    /// - Parameter carbGoal: Carb goal that the user inputted
    /// - Parameter fatGoal: Fat goal that the user inputted
    /// - Parameter weightGoal: Weight goal decided by the user
    func saveProfile(
        name: String,
        age: String,
        gender: String,
        weight: String,
        height: String,
        calorieBudget: String,
        proteinGoal: String,
        carbGoal: String,
        fatGoal: String,
        weightGoal: String
    ) async throws {
        
        // Sets uid
        guard let uid else {
            self.error = "No User Was Signed In"
            return
        }
        // Convert safely from Strings to Correct type
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height),
              let calBudget = Int(calorieBudget),
              let proteinInt = Int(proteinGoal),
              let carbInt = Int(carbGoal),
              let fatInt = Int(fatGoal),
              let weightGoalInt = Int(weightGoal)
        else {
            self.error = "Invalid input"
            return
        }
        
        // validates if weight and height are below 1
        if weightDouble < 1 || heightDouble < 1 {
            self.error = "Invalid input"
            return
        }
        
        // Creates a new variable containing the new profile
        let newProfile = UserProfile(
            name: name,
            age: ageInt,
            gender: gender,
            weight: weightDouble,
            height: heightDouble,
            calorieBudget: calBudget,
            proteinGoal: proteinInt,
            carbGoal: carbInt,
            fatGoal: fatInt,
            weightGoal: weightGoalInt
        )
        
        do {
            // Calls firestoreService method
            try await firestoreService.saveUserProfile(uid: uid, profile: newProfile)
            self.currentUser = newProfile
            self.isRegistered = true
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Resets logs when user logs out
    func resetUser() {
        self.currentUser = nil
        self.isRegistered = false
        self.error = nil
        
        // Reset listener
        listener?.remove()
        listener = nil
    }
    
}
