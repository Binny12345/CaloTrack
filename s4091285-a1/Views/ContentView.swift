//
//  ContentView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI

/// Main View that displays MainTabView and the single sources of truth for 3 ViewModels
struct ContentView: View {
    @StateObject var dailyLogViewModel: DailyLogViewModel
    @StateObject var weightViewModel: WeightViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel

    var body: some View {
        MainTabView(
            weightViewModel: weightViewModel,
            dailyLogViewModel: dailyLogViewModel,
            userProfileViewModel: userProfileViewModel
        )
    }
}

/// MainTabView to store the navigation tab and all pages linked to it
struct MainTabView: View {
    
    // Observes the VM in order to pass it into the different app views
    @ObservedObject var weightViewModel: WeightViewModel
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var selectedTab = 0
    
    
    var body: some View {
        if userProfileViewModel.isRegistered == false {
            OnboardingView(
                weightViewModel: weightViewModel,
                dailyLogViewModel: dailyLogViewModel,
                userProfileViewModel: userProfileViewModel
            )
        }
        else {
            ZStack {
                NavigationStack {
                    TabView(selection: $selectedTab) {
                        DashboardView(
                              weightViewModel: weightViewModel,
                              dailyLogViewModel: dailyLogViewModel,
                              userProfileViewModel: userProfileViewModel
                            )
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
                                .symbolRenderingMode(.palette)
                                .background(.green)
                                .shadow(radius: 5)
                            }
                            .tag(2)
                        
                        WeightInputView(weightViewModel: weightViewModel)
                            .tabItem {
                                Image(systemName: "plus")
                                Text("Add Weight")
                            }
                            .tag(3)
                        
                        SettingsView(dailyLogViewModel: dailyLogViewModel)
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(4)
                        
                    }
                }
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

