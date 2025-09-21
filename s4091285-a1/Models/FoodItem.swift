//
//  FoodItem.swift
//  s4091285-a1
//
//  Food Item Model used for inputting food items
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation
import SwiftData

/// FoodItem is used to store data of each food item and items logged by the user
@Model
class FoodItem {
    var id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
    init(id: UUID = UUID(), name: String, calories: Double, protein: Double, carbs: Double, fats: Double, mealType: String, date: Date) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.mealType = mealType
        self.date = date
    }
}
