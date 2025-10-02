//
//  OpenFoodFactsAPI.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 13/9/2025.
//

import Foundation

/// REST API service for searching foods and fetching by barcode.
class OpenFoodFactsAPI {
    static let shared = OpenFoodFactsAPI()
    private init() { }
    
    /// Calls REST API to search  for food Items
    /// - Parameter query: String that is put into the API to search for the food item
    /// - Parameter completion: returns list of food items
    func searchFoods(query: String, completion: @escaping ([FoodSearchResult]) -> Void) {
        
        // encodes the query and sets url to include query
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(encodedQuery)&search_simple=1&action=process&json=1&page_size=10")
        else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            // Do-catch block to fetch the items from the API
            do {
                let response = try JSONDecoder().decode(OFFSearchResponse.self, from: data)
                let items = response.products.compactMap { product -> FoodSearchResult? in
                    
                    // Organises fetched data into variables to put into a result for user to access
                    guard let name = product.product_name else { return nil }
                    let calories = product.nutriments?.energyKcal ?? 0
                    let protein = product.nutriments?.protein ?? 0
                    let carbs = product.nutriments?.carbs ?? 0
                    let fat = product.nutriments?.fats ?? 0
                    
                    // Returns the fetched item
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
    
    /// Calls REST API to search for the barcode item
    /// - Parameter barcode: Barcode that's converted into a string that is put into the API to search for the food item
    /// - Parameter completion: Optionally returns a food item
    func fetchProduct(by barcode: String, completion: @escaping (FoodSearchResult?) -> Void) {
        // Sets url to include the barcode
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(nil)
                return
            }
            
            // Do-catch block to fetch the barcode item from the API
            do {
                let response = try JSONDecoder().decode(OFFProductResponse.self, from: data)
                
                // Organises fetched data into variables to put into a result for user to access
                if let product = response.product,
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

/// Helper struct to organise the scanned barcode's food item
struct OFFProductResponse: Codable {
    let status: Int
    let code: String
    let product: OFFProduct?
}

/// Helper struct to organise the fetched data
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

/// Helper struct to organise the response of the fetch
struct OFFSearchResponse: Codable {
    let products: [OFFProduct]
}

/// Helper struct to organise the data into a single object
struct OFFProduct: Codable {
    let product_name: String?
    let nutriments: Nutriments?
}

/// Helper struct to organise the macros and format them from the API into CaloTrack's parameters
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
    
    // Custom decoder to handle both numbers and strings
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        energyKcal = try Nutriments.decodeNumber(forKey: .energyKcal, in: container)
        protein = try Nutriments.decodeNumber(forKey: .protein, in: container)
        carbs = try Nutriments.decodeNumber(forKey: .carbs, in: container)
        fats = try Nutriments.decodeNumber(forKey: .fats, in: container)
    }
    
    private static func decodeNumber(forKey key: CodingKeys, in container: KeyedDecodingContainer<CodingKeys>) throws -> Double? {
        if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return doubleValue
        }
        if let stringValue = try? container.decode(String.self, forKey: key) {
            return Double(stringValue)
        }
        return nil
    }
}
