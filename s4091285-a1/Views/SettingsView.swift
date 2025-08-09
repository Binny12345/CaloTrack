//
//  SettingsView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Text("Personal Details")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
