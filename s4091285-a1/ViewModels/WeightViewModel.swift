//
//  WeightViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//
import SwiftUI
import SwiftData

/// WeightViewModel needed to store all the functionality of the WeightInputView
class WeightViewModel: ObservableObject {
    
    private var context: ModelContext
    @Published var weightLogs: [WeightLog] = []
    
    /// Initialises the class with the Loadlogs func
    init(context: ModelContext) {
        self.context = context
        fetchLogs()
    }
    
    
    /// Fetches all weight logs
    func fetchLogs() {
        let descriptor = FetchDescriptor<WeightLog>()
        do {
            weightLogs = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch weight logs: \(error)")
        }
    }
    
    /// Add a log into the current logs
    /// - Parameter weight: The weight inputted by the user
    /// - Parameter date: The date the log was made
    func addLog(weight: Double, date: Date) {
        let newLog = WeightLog(weight: weight, date: date)
        
        context.insert(newLog)
        saveContext()
        fetchLogs()
        print("Successfully added weight log: \(weight) kg on \(date)")
    }
    /// Remove a log into the current logs
    /// - Parameter offsets: The index for which log the user is removing
    func removeLog(withId id: UUID) {
        if let logToDelete = weightLogs.first(where: { $0.id == id }) {
            context.delete(logToDelete)
            saveContext()
            fetchLogs()
            print("Successfully removed weight log.")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}


