//
//  DailyLogViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation
import SwiftUI

/// DailyLogViewModel needed to store all the functionality of the SearchView and FoodDetailView
class DailyLogViewModel: ObservableObject {
    @Published var dailyLogs: [DailyLog] = []
    private var fileName = "DailyLogs.json"
    
    /// Initialises the class with the Loadlogs func
    init() {
        loadLogs()
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
        
        dailyLogs.append(logEntry)
        saveLogs()
        print("Successfully added \(foodItem.name) to daily log.")
    }
    
    /// Removes the food item from the daily log
    func removeLog(withId id: UUID) {
        dailyLogs.removeAll { $0.id == id }
        saveLogs()
        print("Successfully removed 1 food item from daily log.")
    }
    
    /// Removes all food items from daily log
    func clearDailyLogs() {
        let fileManager = FileManager.default
        let url = getFileURL()
        
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
                dailyLogs.removeAll() // Clear in-memory logs too
                print("DailyLogs.json cleared!")
            } catch {
                print("Failed to delete DailyLogs.json: \(error)")
            }
        } else {
            print("No DailyLogs.json file found to delete.")
        }
    }
    
    /// Variable that stores all of the logs for the day
    var todaysLogs: [DailyLog] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        
        return dailyLogs.filter { log in
            log.date >= today && log.date < tomorrow!
        }
    }
    
    /// Grabbing the URL of the JSON file storing the data
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    /// Saves the logs into the JSON file
    private func saveLogs() {
        do {
            let data = try JSONEncoder().encode(dailyLogs)
            let url = getFileURL()
            try data.write(to: url)
            print("Daily Logs saved")
        } catch {
            print("Error with saving logs: \(error)")
        }
    }
    
    /// Loads the data from the JSON file
    private func loadLogs() {
        let url = getFileURL()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("No existing daily log file found - starting fresh")
            dailyLogs = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            dailyLogs = try JSONDecoder().decode([DailyLog].self, from: data)
            print("Loaded \(dailyLogs.count) Daily logs from file")
        } catch {
            print("No saved logs found: \(error)")
            dailyLogs = []
        }
    }
}
