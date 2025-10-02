//
//  FoodItem.swift
//  s4091285-a1
//
//  Food Item Model used for inputting food items
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation
import FirebaseFirestore

/// FoodItem represents a single logged food entry stored in Firebase
struct FoodItem: Identifiable, Codable, Equatable {
    var id: String?
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
    /// Converts to Firestore dictionary
    var asDictionary: [String: Any] {
        [
            "name": name,
            "calories": calories,
            "protein": protein,
            "carbs": carbs,
            "fats": fats,
            "mealType": mealType,
            "date": date
        ]
    }
}
