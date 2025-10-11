//
//  WeightViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//
import SwiftUI
import SwiftData

/// WeightViewModel needed to store all the functionality of the WeightInputView
@MainActor
class WeightViewModel: ObservableObject {
    
    private var context: ModelContext
    var userID: String = ""
    @Published var weightLogs: [WeightLog] = []
    
    /// Initialises the class with the Loadlogs func
    init(context: ModelContext) {
        self.context = context
        fetchWeightLogs()
        print("DEBUG: Context \(context)")
    }
    
    init(context: ModelContext, userID: String) {
        self.context = context
        self.userID = userID
        fetchWeightLogs()
    }
    
    
    /// Fetches all weight logs
    func fetchWeightLogs() {
        print("DEBUG: Fetching on main thread? \(Thread.isMainThread)")
        let descriptor = FetchDescriptor<WeightLog>()
        do {
            weightLogs = try context.fetch(descriptor)
            print("DEBUG: Fetch count \(weightLogs.count)")
        } catch {
            print("Failed to fetch weight logs: \(error)")
        }
    }
    
    /// Add a log into the current logs if one doesn't already exist
    /// - Parameter weight: The weight inputted by the user
    /// - Parameter date: The date the log was made
    func addWeightLog(weight: Double, date: Date, uid: String) -> String {
        let newLog = WeightLog(weight: weight, date: date, userId: uid)
        
        // Validating if user already logged today
        // If they did, block the new log
        let userLogs = weightLogs.filter { $0.userId == uid }
        let alreadyLoggedToday = userLogs.contains { log in
            Calendar.current.isDate(log.date, inSameDayAs: date)
        }
        
        guard !alreadyLoggedToday else {
            return "Already logged a weight for today!"
        }
        context.insert(newLog)
        saveContext()
        fetchWeightLogs()
        
        print("Successfully added weight log: \(weight) kg on \(date)")
        return ""
    }
    /// Remove a log into the current logs
    /// - Parameter id: The index for which log the user is removing
    func removeWeightLog(withId id: UUID) {
        if let logToDelete = weightLogs.first(where: { $0.id == id }) {
            context.delete(logToDelete)
            saveContext()
            fetchWeightLogs()
            print("Successfully removed weight log.")
        }
    }
    
    /// Saves the context into SwiftData
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
}


