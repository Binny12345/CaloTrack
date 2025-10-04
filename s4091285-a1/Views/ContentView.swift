//
//  ContentView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI
import SwiftData
import FirebaseAuth

/// Main View that displays MainTabView and the single sources of truth for multiple ViewModels
struct ContentView: View {
    @StateObject var dailyLogViewModel: DailyLogViewModel
    @StateObject var weightViewModel: WeightViewModel
    @StateObject var authViewModel: AuthViewModel
    @StateObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                // User not signed in -> Show Signin/Onboarding View
                OnboardingView(
                    weightViewModel: weightViewModel,
                    dailyLogViewModel: dailyLogViewModel,
                    userProfileViewModel: userProfileViewModel,
                    authViewModel: authViewModel
                )
            } else if userProfileViewModel.isLoading {
                // Signed in but profile still loading
                ProgressView("Loading...")
            } else if userProfileViewModel.currentUser == nil {
                // Signed in but no profile -> Show FormView to get user info
                FormView(
                    auth: authViewModel,
                    userProfileViewModel: userProfileViewModel,
                    weightViewModel: weightViewModel,
                    dailyLogViewModel: dailyLogViewModel
                )
            } else {
                // Signed in + profile exists -> Show Main App
                MainTabView(
                    weightViewModel: weightViewModel,
                    dailyLogViewModel: dailyLogViewModel,
                    userProfileViewModel: userProfileViewModel,
                    authViewModel: authViewModel
                )
            }
        }
        .onAppear {
            // If the app starts and we're already signed in, fetch profile right away.
            if authViewModel.isAuthenticated {
                Task {
                    await userProfileViewModel.fetchProfile()
                    userProfileViewModel.listenToProfile()
                    dailyLogViewModel.startListening()
                }
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { _, signedIn in
                    Task {
                        if signedIn {
                            // Signed in -> fetch profile (sets isLoading) and attach listener
                            await userProfileViewModel.fetchProfile()
                            userProfileViewModel.listenToProfile()
                            dailyLogViewModel.startListening()
                        } else {
                            // Signed out -> clear everything + remove listeners
                            dailyLogViewModel.reset()
                            userProfileViewModel.resetUser()
                        }
                    }
                }
    }
}

/// MainTabView to store the navigation tab and all pages linked to it
struct MainTabView: View {
    
    // Observes the VM in order to pass it into the different app views
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    
    var body: some View {
        if authViewModel.isAuthenticated {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    DashboardView(
                        weightViewModel: weightViewModel,
                        dailyLogViewModel: dailyLogViewModel,
                        userProfileViewModel: userProfileViewModel
                    )
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(0)
                
                BarcodeView(dailyLogViewModel: dailyLogViewModel)
                    .tabItem {
                        Image(systemName: "barcode.viewfinder")
                        Text("Barcode")
                    }
                    .tag(1)
                
                SearchView(dailyLogViewModel: dailyLogViewModel)
                    .tabItem {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(.green)
                    }
                    .tag(2)
                
                WeightInputView(
                    weightViewModel: weightViewModel,
                    uid: Auth.auth().currentUser?.uid ?? ""
                )
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Add Weight")
                    }
                    .tag(3)
                
                NavigationStack {
                    SettingsView(
                        dailyLogViewModel: dailyLogViewModel,
                        userProfileViewModel: userProfileViewModel,
                        authViewModel: authViewModel
                    )
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
            }
            .preferredColorScheme(.dark)
        }
    }
}

/// Extends upon UIApplication to add functionality for the user
extension UIApplication {
    
    /// Allow for the user to exit out of their keyboard when typing within the application
    func endEditingMode() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

