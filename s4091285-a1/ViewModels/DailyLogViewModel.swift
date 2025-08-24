//
//  DailyLogViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation
import SwiftUI

class DailyLogViewModel: ObservableObject {
    @Published var dailyLogs: [DailyLog] = []
    private var fileName = "DailyLogs.json"
    
    init() {
        loadLogs()
    }
    
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
    
    func removeLog(withId id: UUID) {
        dailyLogs.removeAll { $0.id == id }
        saveLogs()
        print("Successfully removed 1 food item from daily log.")
    }
    
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
    
    var todaysLogs: [DailyLog] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        
        return dailyLogs.filter { log in
            log.date >= today && log.date < tomorrow!
        }
    }
    
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
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
