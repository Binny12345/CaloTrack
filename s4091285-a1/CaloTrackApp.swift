//
//  s4091285_a1App.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI
import SwiftData

/// Main struct that stores the ContentView with the SwiftData model Container source of truth
@main
struct CaloTrackApp: App {
    let container: ModelContainer
    
    init() {
        container = try! ModelContainer(for: FoodItem.self, WeightLog.self, UserProfile.self)
    }
    var body: some Scene {
        WindowGroup {
            ContentView(
                dailyLogViewModel: DailyLogViewModel(context: container.mainContext),
                weightViewModel: WeightViewModel(context: container.mainContext),
                userProfileViewModel: UserProfileViewModel(context: container.mainContext),
            )
            .modelContainer(container)
            .preferredColorScheme(.dark)
        }
    }
}
