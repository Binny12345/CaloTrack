//
//  OpenFoodFactsAPI.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 13/9/2025.
//

import Foundation

class OpenFoodFactsAPI {
    static let shared = OpenFoodFactsAPI()
    private init() { }
    
    // Search Food Items
    func searchFoods(query: String, completion: @escaping ([FoodSearchResult]) -> Void) {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(encodedQuery)&search_simple=1&action=process&json=1")
        else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            do {
                let response = try JSONDecoder().decode(OFFSearchResponse.self, from: data)
                let items = response.products.compactMap { product -> FoodSearchResult? in
                    
                    guard let name = product.product_name else { return nil }
                    let calories = product.nutriments?.energyKcal ?? 0
                    let protein = product.nutriments?.protein ?? 0
                    let carbs = product.nutriments?.carbs ?? 0
                    let fat = product.nutriments?.fats ?? 0
                    
                   return FoodSearchResult(
                             name: name,
                             calories: calories,
                             protein: protein,
                             carbs: carbs,
                             fats: fat,
                             mealType: "Snack",
                             date: Date()
                    )
                }
                DispatchQueue.main.async {
                    completion(items)
                }
            } catch {
                print("Failed to decode OFF Response: ", error)
                completion([])
            }
        }.resume()
    }
    
    
    func fetchProduct(by barcode: String, completion: @escaping (FoodSearchResult?) -> Void) {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode([String: OFFProduct].self, from: data)
                if let product = response["product"],
                   let name = product.product_name {
                    
                    let item = FoodSearchResult(
                        name: name,
                        calories: product.nutriments?.energyKcal ?? 0.0,
                        protein: product.nutriments?.protein ?? 0.0,
                        carbs: product.nutriments?.carbs ?? 0.0,
                        fats: product.nutriments?.fats ?? 0.0,
                        mealType: "Snack",
                        date: Date()
                    )
                    DispatchQueue.main.async { completion(item) }
                    print(item.calories)
                    print(item.protein)
                }  else {
                    completion(nil)
                }
                
            } catch {
                print("Failed to decode barcode: ", error)
                completion(nil)
            }
        }.resume()
    }
}

struct FoodSearchResult: Identifiable {
    let id = UUID()
    let name: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fats: Double
    let mealType: String
    let date: Date
}

struct OFFSearchResponse: Codable {
    let products: [OFFProduct]
}

struct OFFProduct: Codable {
    let product_name: String?
    let nutriments: Nutriments?
}

struct Nutriments: Codable {
    let energyKcal: Double?
    let protein: Double?
    let carbs: Double?
    let fats: Double?
    
    enum CodingKeys: String, CodingKey {
        case energyKcal = "energy-kcal_100g"
        case protein = "proteins_100g"
        case carbs = "carbohydrates_100g"
        case fats = "fat_100g"
    }
}
