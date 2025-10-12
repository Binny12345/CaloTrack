//
//  Firebase.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 25/9/2025.
//

import Foundation
import FirebaseFirestore

/// Handles the business log between Firebase Firestore Database and CaloTrack
struct FirestoreService {
    private let db = Firestore.firestore()
    
    // Helper functions for convering values in firebase to SwiftUI
    /// Helps convert the double within Firebase to double in project
    private func asDouble(_ any: Any?) -> Double? {
        if let d = any as? Double { return d }
        if let i = any as? Int { return Double(i) }
        if let i64 = any as? Int64 { return Double(i64) }
        if let s = any as? String, let dd = Double(s) { return dd }
        return nil
    }

    /// Helps convert the date within Firebase to Date in project
    private func asDate(_ any: Any?) -> Date? {
        if let ts = any as? Timestamp { return ts.dateValue() }
        if let d = any as? Date { return d }
        if let s = any as? String {
            // optional: try ISO8601 parse; simple fallback:
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: s)
        }
        return nil
    }
    
    // MARK: - UserProfile
    
    /// Saves or updates the user profile at `users\{uid}`
    func saveUserProfile(uid: String, profile: UserProfile) async throws {
        try await db.collection("users")
            .document(uid)
            .setData(profile.asDictionary, merge: true)
    }
    
    /// Fetches user profile
    func fetchUserProfile(uid: String) async throws -> UserProfile? {
        let doc = try await db.collection("users").document(uid).getDocument()
        guard let data = doc.data() else { return nil }
        
        return try mapToUserProfile(data: data)
    }
    
    /// Listen to user profile for real time updates
    /// - Parameter uid: id of the user
    func listenToUserProfile(uid: String, onChange: @escaping (UserProfile?) -> Void) -> ListenerRegistration {
        return db.collection("users")
            .document(uid)
            .addSnapshotListener { snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    onChange(nil)
                    return
                }
                onChange(try? mapToUserProfile(data: data))
            }
    }
    
    // MARK: - FoodItem
    
    /// Save a food item under `users/{uid}/foodLogs/{foodId}`
    func addFoodItem(uid: String, foodItem: FoodItem) async throws {
        try await db.collection("users")
            .document(uid)
            .collection("foodLogs")
            .addDocument(data: foodItem.asDictionary)
    }
    
    /// Fetch all food items for a user (one-time load)
    /// - Parameter uid: User id
    func fetchFoodItems(uid: String) async throws -> [FoodItem] {
        let snapshot = try await db.collection("users")
            .document(uid)
            .collection("foodLogs")
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            guard
                let name = data["name"] as? String,
                let calories = asDouble(data["calories"]),
                let protein = asDouble(data["protein"]),
                let carbs = asDouble(data["carbs"]),
                let fats = asDouble(data["fats"]),
                let mealType = data["mealType"] as? String,
                let date = asDate(data["date"])
            else {
                print("Invalid FoodItem data for doc \(doc.documentID)")
                return nil
            }
            
            return FoodItem(
                id: doc.documentID,
                name: name,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                mealType: mealType,
                date: date
            )
        }
    }
    
    /// Listen to food items for real-time updates
    /// - Parameter uid: User id
    func listenToFoodItems(uid: String, onChange: @escaping ([FoodItem]) -> Void) -> ListenerRegistration {
        db.collection("users")
            .document(uid)
            .collection("foodLogs")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Error listening for FoodItems: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                print("Firestore listenToFoodItems: got \(snapshot.documents.count) documents")
                
                var items: [FoodItem] = []
                
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                    guard
                        let name = data["name"] as? String,
                        let calories = asDouble(data["calories"]),
                        let protein = asDouble(data["protein"]),
                        let carbs = asDouble(data["carbs"]),
                        let fats = asDouble(data["fats"]),
                        let mealType = data["mealType"] as? String,
                        let date = asDate(data["date"])
                    else {
                        print("Invalid FoodItem data for doc \(doc.documentID)")
                        continue
                    }
                    
                    let foodItem = FoodItem(
                        id: doc.documentID,
                        name: name,
                        calories: calories,
                        protein: protein,
                        carbs: carbs,
                        fats: fats,
                        mealType: mealType,
                        date: date
                    )
                    
                    items.append(foodItem)
                }
                print("Successfully mapped \(items.count) FoodItems")
                onChange(items)
            }
    }
    
    /// Delete a food item
    /// - Parameter uid: User id
    /// - Parameter foodId: id of the food item
    func deleteFoodItem(uid: String, foodItem: FoodItem) async throws {
        guard let id = foodItem.id else { return }
        try await db.collection("users")
            .document(uid)
            .collection("foodLogs")
            .document(id)
            .delete()
    }
    
    // MARK: Mapping Helper Functions
    
    /// Helps connect to UserProfile Model
    ///  - Parameter data: Data from the DB
    private func mapToUserProfile(data: [String: Any]) throws -> UserProfile {
        guard
            let name = data["name"] as? String,
            let age = data["age"] as? Int,
            let gender = data["gender"] as? String,
            let weight = data["weight"] as? Double,
            let height = data["height"] as? Double,
            let calorieBudget = data["calorieBudget"] as? Int,
            let proteinGoal = data["proteinGoal"] as? Int,
            let carbGoal = data["carbGoal"] as? Int,
            let fatGoal = data["fatGoal"] as? Int,
            let weightGoal = data["weightGoal"] as? Int
        else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UserProfile data"])
        }
        
        return UserProfile(
            name: name,
            age: age,
            gender: gender,
            weight: weight,
            height: height,
            calorieBudget: calorieBudget,
            proteinGoal: proteinGoal,
            carbGoal: carbGoal,
            fatGoal: fatGoal,
            weightGoal: weightGoal
        )
    }
    
    /// Helps connect to FoodItem Model
    ///  - Parameter data: Data from the DB
    private func mapToFoodItem(data: [String: Any]) throws -> FoodItem {
        guard
            let name = data["name"] as? String,
            let calories = data["calories"] as? Double,
            let protein = data["protein"] as? Double,
            let carbs = data["carbs"] as? Double,
            let fats = data["fats"] as? Double,
            let mealType = data["mealType"] as? String,
            let timestamp = data["date"] as? Timestamp
        else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid FoodItem data"])
        }
        
        return FoodItem(
            name: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            mealType: mealType,
            date: timestamp.dateValue()
        )
    }
}
