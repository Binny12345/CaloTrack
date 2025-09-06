//
//  WeightLog.swift
//  s4091285-a1
//
//  WeightLog Model used for inputting weight and tracking progress
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation
import SwiftData

/// WeightLog needed to store the weight of the user
@Model
class WeightLog {
    var id = UUID()
    var weight: Double
    var date: Date
    
    init(id: UUID = UUID(), weight: Double, date: Date = Date()) {
        self.id = id
        self.weight = weight
        self.date = date
    }
}
