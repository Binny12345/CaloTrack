//
//  DataManager.swift
//  s4091285-a1
//
//  Manages the Data within Data.json and prepares it to be accessed
//
//  Created by Binyam Sisay on 13/8/2025.
//

import Foundation

/// DataManager needed to handle the food items from the API calls
struct DataManager {
        

}

// Dummy code for accessing JSON data:
//static func loadFoodData() -> [FoodItem] {
//    
//    guard let url = Bundle.main.url(forResource: "Data", withExtension: "json") else {
//        print("JSON File not found")
//        return []
//    }
//    do {
//        let data = try Data(contentsOf: url)
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return try decoder.decode([FoodItem].self, from: data)
//    } catch {
//        print("Error decoding JSON: \(error)")
//        return []
//    }
//}
