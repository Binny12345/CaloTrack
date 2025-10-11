 //
//  s4091285_a1Widgets.swift
//  s4091285-a1Widgets
//
//  Created by Binyam Sisay on 11/10/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    /// Defined as a backup data
    func placeholder(in context: Context) -> CalorieEntry {
        CalorieEntry(
            date: Date(),
            caloriesConsumed: 1200,
            calorieGoal: 2000,
            protein: 80,
            carbs: 150,
            fats: 50
        )
    }

    /// Grabs the snapshot of the data context
    /// - Parameter context: The context of the widget
    /// - Parameter completion: How the data should return
    func getSnapshot(in context: Context, completion: @escaping (CalorieEntry) -> Void) {
        let entry = loadUserData()
        completion(entry)
    }

    /// Sets the actual live data
    /// - Parameter context: The context of the widget
    /// - Parameter completion: How the data should return
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalorieEntry>) -> Void) {
        let entry = loadUserData()
        print("DEBUG - loadUserData(): \(entry) ")
        
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 1))) // refresh every 1 min
        completion(timeline)
    }
    
    /// Loads user data gathered from connecting "UpdateWidgetData( )" func in DailyLogViewModel
    private func loadUserData() -> CalorieEntry {
        
        // Pull data from shared UserDefaults App Group
        let defaults = UserDefaults(suiteName: "group.rmit-IPSE.s4091285-a1")
        let consumed = defaults?.double(forKey: "caloriesConsumed") ?? 0
        let goal = defaults?.double(forKey: "calorieGoal") ?? 2000
        let protein = defaults?.double(forKey: "proteinConsumed") ?? 0
        let carbs = defaults?.double(forKey: "carbsConsumed") ?? 0
        let fats = defaults?.double(forKey: "fatsConsumed") ?? 0

        return CalorieEntry(
            date: Date(),
            caloriesConsumed: consumed,
            calorieGoal: goal,
            protein: protein,
            carbs: carbs,
            fats: fats
        )
    }

}


