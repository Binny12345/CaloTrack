//
//  UserProfile.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 12/9/2025.
//

import Foundation
import SwiftData

/// UserProfile stores the details of the registered user
@Model
class UserProfile {
    var id: UUID
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
    
    init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        gender: String,
        weight: Double,
        height: Double,
        calorieBudget: Int,
        proteinGoal: Int,
        carbGoal: Int,
        fatGoal: Int,
        weightGoal: Int
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.weight = weight
        self.height = height
        self.calorieBudget = calorieBudget
        self.proteinGoal = proteinGoal
        self.carbGoal = carbGoal
        self.fatGoal = fatGoal
        self.weightGoal = weightGoal
    }
}
