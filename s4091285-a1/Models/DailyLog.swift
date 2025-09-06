//
//  DailyLog.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation
import SwiftData

/// DailyLog needed to store the food items of the user for the day
@Model
class DailyLog {
    var id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
    /// Enum needed to organise the DailyLog struct
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
