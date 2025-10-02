//
//  AuthViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 24/9/2025.
//

import Foundation

import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String?
    @Published var isAuthenticated: Bool
    @Published var user: User?
    
    var userId: String? { user?.uid }

    init() {
        // Initialize user + isAuthenticated consistently
        let current = Auth.auth().currentUser
        _user = Published(initialValue: current)
        _isAuthenticated = Published(initialValue: (current != nil))

        // Attach auth state listener
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = (user != nil)
        
        }
    }
    
    func signUp() async {
        error = nil
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func signIn() async {
        error = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func signOut() {
         error = nil
         do {
             try Auth.auth().signOut()
             self.user = nil
             self.isAuthenticated = false
         } catch {
             self.error = error.localizedDescription
         }
     }
}
