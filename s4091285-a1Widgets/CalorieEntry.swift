//
//  CalorieEntry.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 11/10/2025.
//

import Foundation
import WidgetKit
import SwiftUI

/// Model that defines that data is displayed in the widgets
struct CalorieEntry: TimelineEntry {
    let date: Date
    let caloriesConsumed: Double
    let calorieGoal: Double
    let protein: Double
    let carbs: Double
    let fats: Double
}
