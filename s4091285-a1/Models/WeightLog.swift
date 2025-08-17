//
//  WeightLog.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import Foundation

struct WeightLog: Identifiable, Codable {
    var id = UUID()
    var weight: Double
    var date: Date
}
