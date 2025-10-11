//
//  s4091285_a1App.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

/// Main struct that stores the ContentView with the SwiftData model Container source of truth
@main
struct CaloTrackApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: WeightLog.self)
            print("Model Container created successfully.")
        } catch {
            // Fallback container to satisfy compiler requirements
            print("Failed to create Model Container: \(error.localizedDescription)")
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try! ModelContainer(for: WeightLog.self, configurations: config)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                dailyLogViewModel: DailyLogViewModel(),
                weightViewModel: WeightViewModel(context: container.mainContext),
                authViewModel: AuthViewModel(),
                userProfileViewModel: UserProfileViewModel(),
            )
            .modelContainer(container)
            .preferredColorScheme(.dark)
        }
    }
}
