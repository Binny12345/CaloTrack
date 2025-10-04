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

/// WeightLog is used to store the weight of the user
@Model
final class WeightLog {
    @Attribute(.unique) var id = UUID()
    var weight: Double
    var date: Date
    var userId: String // The Firebase UID tied to weight logs
    
    init(id: UUID = UUID(), weight: Double, date: Date = Date(), userId: String) {
        self.id = id
        self.weight = weight
        self.date = date
        self.userId = userId
    }
}
