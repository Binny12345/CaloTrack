//
//  DailyLog.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 21/8/2025.
//

import Foundation

/// DailyLog needed to store the food items of the user for the day
struct DailyLog: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
    /// Enum needed to organise the DailyLog struct
    private enum CodingKeys: String, CodingKey {
            case name, calories, protein, carbs, fats, mealType, date
        }
}
