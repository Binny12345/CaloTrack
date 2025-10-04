//
//  SettingsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// SettingsView for the user to view their settings
struct SettingsView: View {
    
    // Passed in objects
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var clearLogsPopover: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                
                // MARK: Personal Details/Historical Data
                NavigationLink(destination: PersonalDetailsView(userProfileViewModel: userProfileViewModel)) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Personal Details")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 3)
                    .cornerRadius(3)
                }
                .foregroundStyle(.green)
                    
                // Sends user to HistoricalDataView
                NavigationLink(destination: HistoricalDataView(dailyLogViewModel: dailyLogViewModel)) {
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Historical Data")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 3)
                    .cornerRadius(3)
                }
                .foregroundStyle(.green)
            }
            
            Section {
                // MARK: Clear Logs
                Button {
                    clearLogsPopover.toggle()
                } label: {
                    Text("Clear Logs For The Day")
                        .foregroundStyle(.red)
                }
                
                // Signs user out
                Button {
                    authViewModel.signOut()
                    userProfileViewModel.resetUser()
                } label: {
                    Text("Sign Out")
                        .foregroundStyle(.red)
                }
            }
            // Displays a confirmation message
            .popover(isPresented: $clearLogsPopover) {
                VStack() {
                    Text("This action will remove all of your log entries for the day. \nAre you sure?")
                        .multilineTextAlignment(.center)
                    
                    // Clears logs from DB and exits the popover
                    Button() {
                        clearLogsPopover = false
                       // dailyLogViewModel.clearDailyLogs()
                    } label: {
                        Text("Confirm")
                            .foregroundStyle(.red)
                    }
                    .padding()
                    
                    Button() {
                        clearLogsPopover = false
                    } label: {
                        Text("Exit")
                            .foregroundStyle(.green)
                    }
                    
                }
            }
        }
        .navigationTitle("Settings")
    }
}

