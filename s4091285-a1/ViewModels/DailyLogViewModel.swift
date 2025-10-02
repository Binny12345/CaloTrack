//
//  DailyLogViewModel.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

/// DailyLogViewModel needed to store all the functionality of the SearchView and FoodDetailView
@MainActor
class DailyLogViewModel: ObservableObject {
    
    // Variabes
    @Published var dailyLogs: [FoodItem] = []
    
    private var firestoreService = FirestoreService()
    private var listener: ListenerRegistration?
    
    private var uid: String? {
        Auth.auth().currentUser?.uid
    }
    
    // MARK: - Computed Nutrition Totals
    var totalCaloriesToday: Int {
        todaysLogs.reduce(0) { $0 + Int($1.calories) }
    }
    var totalProteinToday: Int {
        todaysLogs.reduce(0) { $0 + Int($1.protein) }
    }
    var totalCarbsToday: Int {
        todaysLogs.reduce(0) { $0 + Int($1.carbs) }
    }
    var totalFatsToday: Int {
        todaysLogs.reduce(0) { $0 + Int($1.fats) }
    }
    
      
    // MARK: - Firebase Listeners
    
    /// Start listening to **today’s logs only**
    func startListening() {
        listener?.remove()
        guard let uid else { return }

        listener = firestoreService.listenToFoodItems(uid: uid) { [weak self] items in
            guard let self else { return }

            print("Fetched \(items.count) total logs from Firestore for user \(uid)")

            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())

            let todaysItems = items.filter { log in
                let logDay = calendar.startOfDay(for: log.date)
                return logDay == today
            }

            print("Filtered to \(todaysItems.count) logs for today (\(today))")

            self.dailyLogs = todaysItems
        }
    }
    
    /// Fetches all logs in Descending order
    func fetchAllLogsDescending() async {
        guard let uid else { return }
        
        do {
            let items = try await firestoreService.fetchFoodItems(uid: uid)
            self.dailyLogs = items.sorted { $0.date > $1.date }
        } catch {
            print("Failed to fetch logs: \(error.localizedDescription)")
            self.dailyLogs = []
        }
    }
    
    // MARK: CRUD Functionality
    
    /// Adds a food item to the user's daily log
    /// - Parameter foodItem: The selected food item the user chose
    /// - Parameter mealType: What type of meal is the food item
    func addFoodToLog(foodItem: FoodItem, mealType: String = "Snack") async {
        guard let uid else { return }
        let logEntry = FoodItem(
            id: nil,
            name: foodItem.name,
            calories: foodItem.calories,
            protein: foodItem.protein,
            carbs: foodItem.carbs,
            fats: foodItem.fats,
            mealType: mealType,
            date: Date()
        )
        
        do {
            try await firestoreService.addFoodItem(uid: uid, foodItem: logEntry)
            print("Successfully added \(foodItem.name) to your Daily Log!")
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }
    
    /// Removes a food item from the dailyLog by its Firestore document ID
    /// - Parameter item: The specified food item to be removed
    func removeFoodLog(_ item: FoodItem) async {
        guard let uid else { return }
        do {
            try await firestoreService.deleteFoodItem(uid: uid, foodItem: item)
            print("Successfully removed food log.")
        } catch {
            print("Failed to delete log: \(error.localizedDescription)")
        }
    }
    
    /// Variable that stores all of the logs for the day
    var todaysLogs: [FoodItem] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return dailyLogs.filter { log in
            let logDay = calendar.startOfDay(for: log.date)
            return logDay == today
        }
    }
    
    /// Removes all food items from daily log
    func clearDailyLogs() async {
        for log in todaysLogs {
            await removeFoodLog(log)
        }
    }
    
    /// Resets logs when user logs out
    func reset() {
        listener?.remove()
        dailyLogs = []
    }
    
    /// Deinitialises the listener registration
    deinit {
        listener?.remove()
    }

}

