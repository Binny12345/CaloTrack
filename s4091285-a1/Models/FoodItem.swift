//
//  FoodItem.swift
//  s4091285-a1
//
//  Food Item Model used for inputting food items
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation

struct FoodItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var mealType: String
    var date: Date
    
    private enum CodingKeys: String, CodingKey {
            case name, calories, protein, carbs, fats, mealType, date
        }
}
