//
//  FatSecretAPI.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 3/9/2025.
//

import Foundation
import SwiftData

/// If struct was used, would lose token cache everytime struct was crated and destroyed from re-rendering
class FatSecretAPI {
    static let shared = FatSecretAPI()
    
    private let clientId: String
    private let clientSecret: String
    private var accessToken: String?
    private var tokenExpiration: Date?
    
    init() {
        self.clientId = Bundle.main.object(forInfoDictionaryKey: "FATSECRET_CLIENT_ID") as? String ?? ""
        self.clientSecret = Bundle.main.object(forInfoDictionaryKey: "FATSECRET_CLIENT_SECRET") as? String ?? ""
    }
    
    // Fetch OAuth2 Token request
    func fetchAccessToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://oauth.fatsecret.com/connect/token") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "grant_type=client_credentials&scope=basic"
        request.httpBody = body.data(using: .utf8)
        
        let authString = "\(clientId):\(clientSecret)"
        guard let authData = authString.data(using: .utf8) else {
            completion(nil)
            return
        }
        
        let authHeader = "Basic \(authData.base64EncodedString())"
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TokenResponse.self, from: data)
                self.accessToken = response.access_token
                self.tokenExpiration = Date().addingTimeInterval(TimeInterval(response.expires_in))
                completion(response.access_token)
            } catch {
                completion(nil)
            }
        }
        .resume()
    }
    
    // Search Food Items
    func searchFoods(query: String, completion: @escaping ([FoodItem]) -> Void) {
        ensureValidToken { token in
            guard let token else {
                completion([])
                return
            }
            
            var urlComponents = URLComponents(string: "https://platform.fatsecret.com/rest/server.api")!
            urlComponents.queryItems = [
                URLQueryItem(name: "method", value: "foods.search"),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "search_expression", value: query)
            ]
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else {
                    completion([])
                    return
                }
                do {
                    let response = try JSONDecoder().decode(FatSecretSearchResponse.self, from: data)
                    let items = response.foods.food.map {
                        FoodItem(name: $0.food_name,
                                 calories: Double($0.food_description.extractCalories()) ?? 0,
                                 protein: 0,
                                 carbs: 0,
                                 fats: 0,
                                 mealType: "Snack",
                                 date: Date())
                    }
                    completion(items)
                } catch {
                    completion([])
                }
            }.resume()
        }
    }
    
    private func ensureValidToken(completion: @escaping (String?) -> Void) {
        if let token = accessToken, let expiration = tokenExpiration, expiration > Date() {
            completion(token)
        } else {
            fetchAccessToken(completion: completion)
        }
    }
}

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

struct FatSecretSearchResponse: Codable {
    let foods: FoodList
}

struct FoodList: Codable {
    let food: [FoodSummary]
}

struct FoodSummary: Codable {
    let food_name: String
    let food_description: String
}
    
extension String {
    func extractCalories() -> Double {
        return extractValue(for: "Calories")
    }
    
    func extractProtein() -> Double {
        return extractValue(for: "Protein")
    }
    
    func extractCarbs() -> Double {
        return extractValue(for: "Carbs")
    }
    
    func extractFats() -> Double {
        return extractValue(for: "Fat")
    }
    
    private func extractValue(for nutrient: String) -> Double {
        // Regex matches output fetched from API e.g. "Protein: 1.1g" or "Carbs: 23 g"
        let pattern = "\(nutrient):\\s*([\\d.]+)"
        if let match = self.range(of: pattern, options: .regularExpression) {
            let numberString = String(self[match])
                .replacingOccurrences(of: "\(nutrient):", with: "")
                .trimmingCharacters(in: .whitespaces)
            return Double(numberString) ?? 0
        }
        return 0
    }
}


