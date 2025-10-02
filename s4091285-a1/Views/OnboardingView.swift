//
//  OnboardingView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/9/2025.
//

import SwiftUI

/// To Show the initial screen when user first downloads the app
struct OnboardingView: View {
    
    // Observed objects to pass into FormView
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Gradient Background
                LinearGradient(
                    colors: [.green.opacity(0.8), .green.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea() // Makes background go to edge of screen
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    // Text
                    Text("Welcome To CaloTrack!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Subtitle
                    Text("Track your calories and stay healthy")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    NavigationLink(destination: SigninView(auth: authViewModel, weightViewModel: weightViewModel, dailyLogViewModel: dailyLogViewModel, userProfileViewModel: userProfileViewModel)) {
                        Text("Continue")
                            .frame(width: 300, height: 50)
                            .background(.green)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

