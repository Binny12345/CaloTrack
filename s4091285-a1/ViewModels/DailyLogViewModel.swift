//
//  DailyLogViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation
import SwiftUI
import SwiftData

/// DailyLogViewModel needed to store all the functionality of the SearchView and FoodDetailView
class DailyLogViewModel: ObservableObject {
    
    private var context: ModelContext
    @Published var dailyLogs: [DailyLog] = []
    
    /// Initialises the class with the context from DailyLog Model
    /// - Parameter context: Grabbing the context from CaloTrackApp.Swift to make the data persistent
    init(context: ModelContext) {
        self.context = context
        fetchTodaysLogs()
    }
      
    /// Fetches for all logs
    func fetchTodaysLogs() {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today.addingTimeInterval(86400)
        
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate { log in
                log.date >= today && log.date < tomorrow
            }
        )
        do {
            dailyLogs = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch today's logs: \(error)")
            dailyLogs = []
        }
    }
    
    func fetchAllLogsDescending() {
        let descriptor = FetchDescriptor<DailyLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            dailyLogs = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch all logs: \(error)")
            dailyLogs = []
        }
    }
    
    /// Adds a food item to the user's daily log
    /// - Parameter foodItem: The selected food item the user chose
    /// - Parameter mealType: What type of meal is the food item
    func addFoodToLog(foodItem: FoodItem, mealType: String = "Snack") {
        let logEntry = DailyLog(
            name: foodItem.name,
            calories: foodItem.calories,
            protein: foodItem.protein,
            carbs: foodItem.carbs,
            fats: foodItem.fats,
            mealType: mealType,
            date: Date()
        )
        
        context.insert(logEntry)
        saveContext()
        fetchTodaysLogs()
        print("Successfully added \(foodItem.name) to daily log.")
    }
    
    /// Removes the food item from the daily log
    /// - Parameter id: The specified id for each food item
    func removeLog(withId id: UUID) {
        if let logToDelete = dailyLogs.first(where: { $0.id == id }) {
            context.delete(logToDelete)
            saveContext()
            fetchTodaysLogs()
            
            print("Successfully removed 1 food item from daily log.")
        }
    }
    
    /// Variable that stores all of the logs for the day
    var todaysLogs: [DailyLog] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        return dailyLogs.filter { log in
            guard log.date >= today && log.date < tomorrow else { return false }
            return true
        }
    }
    
    /// Removes all food items from daily log
    func clearDailyLogs() {
        for log in dailyLogs {
            context.delete(log)
        }
        saveContext()
        fetchTodaysLogs()
        print("All logs cleared!")
    }
    
    /// Saves the context of DailyLogs
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

}

