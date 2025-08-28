//
//  SettingsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// SettingsView for the user to view their settings
struct SettingsView: View {
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    @State private var clearLogsPopover: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                
                // MARK: Personal Details/Historical Data
                Button("Personal Details") {
                    // Link to personal detail page
                }
                .foregroundStyle(.green)
                    
                
                Button("Historical Data") {
                    // Link to Data page
                }
                .foregroundStyle(.green)
            }
            
            // MARK: Clear Logs
            Button {
                clearLogsPopover.toggle()
            } label: {
                Text("Clear Logs For The Day")
                    .foregroundStyle(.red)
            }
            .popover(isPresented: $clearLogsPopover) {
                VStack() {
                    Text("This action will remove all of your log entries for the day. \nAre you sure?")
                        .multilineTextAlignment(.center)
                    
                    Button() {
                        clearLogsPopover = false
                        dailyLogViewModel.clearDailyLogs()
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

#Preview {
    SettingsView(dailyLogViewModel: DailyLogViewModel())
}
