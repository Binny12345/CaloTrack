//
//  WeightViewModel.swift
//  s4091285-a1
//
//  Model for WeightView to manipulate the data within the views
//
//  Created by Binyam Sisay on 8/8/2025.
//
import SwiftUI

class WeightViewModel: ObservableObject {
    @Published var logs: [WeightLog] = []
    private let fileName = "WeightLogData.json"
    
    init() {
        loadLogs()
    }
    
    func addLog(weight: Double, date: Date) {
        let newLog = WeightLog(weight: weight, date: date)
        logs.append(newLog)
        print("Log added")
    }
    
    func removeLog(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
        print("logs removed")
    }
    
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    private func saveLogs() {
        do {
            let data = try JSONEncoder().encode(logs)
            try data.write(to: getFileURL())
            print("Logs saved")
        } catch {
            print("Failed to save logs: \(error)")
        }
    }
    
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


