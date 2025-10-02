//
//  UserProfile.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 12/9/2025.
//

import Foundation
import FirebaseFirestore

/// UserProfile stores the details of the registered user into Firebase
struct UserProfile: Codable {
    var name: String
    var age: Int
    var gender: String
    var weight: Double
    var height: Double
    var calorieBudget: Int
    var proteinGoal: Int
    var carbGoal: Int
    var fatGoal: Int
    var weightGoal: Int
    
    
    
    var asDictionary: [String: Any] {
        [
            "name": name,
            "age": age,
            "gender": gender,
            "weight": weight,
            "height": height,
            "calorieBudget": calorieBudget,
            "proteinGoal": proteinGoal,
            "carbGoal": carbGoal,
            "fatGoal": fatGoal,
            "weightGoal": weightGoal
        ]
    }
}
