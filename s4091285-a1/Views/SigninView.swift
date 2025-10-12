//
//  SigninView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 24/9/2025.
//

import SwiftUI

/// Page for the user to input their Login details or Register
struct SigninView: View {
    
    // Observed objects
    @ObservedObject var auth: AuthViewModel
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    @State private var navigateToFormView: Bool = false
    
    
    var body: some View {
        VStack(spacing: 16) {
            Text("CaloTrack")
                .font(.largeTitle)
                .bold()
            
            // Email TextField
            TextField("Email", text: $auth.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Password TextField (SecureField)
            SecureField("Password (min 6+ characters)", text: $auth.password)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // If an error exists, display it to the user
            if let error = auth.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            // Sign In/Up buttons
            HStack {
                Button("Sign In") {
                    Task {
                        await auth.signIn()
                        print("Signed in UID: \(auth.user?.uid ?? "No User Found")")
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Sign Up") {
                    Task {
                        await auth.signUp()
                        print("Signed up UID: \(auth.user?.uid ?? "No User Found")")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

