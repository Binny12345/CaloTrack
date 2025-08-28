//
//  WeightViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//
import SwiftUI

/// WeightViewModel needed to store all the functionality of the WeightInputView
class WeightViewModel: ObservableObject {
    @Published var logs: [WeightLog] = []
    private let fileName = "WeightLogData.json"
    
    /// Initialises the class with the Loadlogs func
    init() {
        loadLogs()
    }
    
    /// Add a log into the current logs
    /// - Parameter weight: The weight inputted by the user
    /// - Parameter date: The date the log was made
    func addLog(weight: Double, date: Date) {
        let newLog = WeightLog(weight: weight, date: date)
        logs.append(newLog)
        print("Log added")
    }
    /// Remove a log into the current logs
    /// - Parameter offsets: The index for which log the user is removing
    func removeLog(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
        print("logs removed")
    }
    
    /// Grabbing the URL of the JSON file storing the data
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    /// Saves the logs into the JSON file
    private func saveLogs() {
        do {
            let data = try JSONEncoder().encode(logs)
            try data.write(to: getFileURL())
            print("Logs saved")
        } catch {
            print("Failed to save logs: \(error)")
        }
    }
    
    /// Loads the data from the JSON file
    private func loadLogs() {
        let url = getFileURL()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("No existing weight log file found - starting fresh")
            logs = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            logs = try JSONDecoder().decode([WeightLog].self, from: data)
            print("Loaded \(logs.count) logs from file")
        } catch {
            print("No saved logs found: \(error)")
            logs = []
        }
    }
}


