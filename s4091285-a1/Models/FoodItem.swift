//
//  FoodItem.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
}
